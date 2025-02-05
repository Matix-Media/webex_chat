import { serve } from "@hono/node-server";
import { config as initEnv } from "dotenv";
import { Hono } from "hono";

initEnv();

const app = new Hono();

const CLIENT_ID = process.env.WEBEX_CLIENT_ID;
const CLIENT_SECRET = process.env.WEBEX_CLIENT_SECRET;
const SCOPES = process.env.WEBEX_SCOPES;

if (!CLIENT_ID || !CLIENT_SECRET || !SCOPES) {
    throw new Error("One of the following environment variables are missing: WEBEX_CLIENT_ID, WEBEX_CLIENT_SECRET, WEBEX_SCOPES");
}

app.get("/health", async (c) => {
    return c.json({ status: "ok" });
});

app.get("/device/authorize", async (c) => {
    const res = await fetch("https://webexapis.com/v1/device/authorize", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
            client_id: CLIENT_ID,
            scope: SCOPES,
        }),
    });

    if (res.status !== 200) {
        console.error("Failed to start device grant flow: " + (await res.text()));
        return c.json({ error: "Failed to authorize device" }, 500);
    }

    const data = await res.json();
    return c.json(data);
});

app.post("/device/token", async (c) => {
    const { deviceCode } = await c.req.json();

    if (!deviceCode) {
        return c.json({ error: "Missing device code" }, 400);
    }

    const res = await fetch("https://webexapis.com/v1/device/token", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            Authorization: `Basic ${Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString("base64")}`,
        },
        body: new URLSearchParams({
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            device_code: deviceCode,
            grant_type: "urn:ietf:params:oauth:grant-type:device_code",
        }),
    });

    // Precondition failed status code 428
    if (res.status === 428) {
        return c.json({ error: "User has not logged in yet" }, 428);
    }

    if (res.status !== 200) {
        console.error("Failed to complete device grant flow: " + (await res.text()));
        return c.json({ error: "Failed to get token" }, 500);
    }

    const data = await res.json();
    return c.json(data);
});

app.post("/refresh", async (c) => {
    const { refreshToken } = await c.req.json();

    if (!refreshToken) {
        return c.json({ error: "Missing refresh token" }, 400);
    }

    const res = await fetch("https://webexapis.com/v1/access_token", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            refresh_token: refreshToken,
            grant_type: "refresh_token",
        }),
    });

    if (res.status === 400) {
        return c.json({ error: "Invalid refresh token" }, 400);
    }

    if (res.status !== 200) {
        console.error("Failed to refresh access token: " + (await res.text()));
        return c.json({ error: "Failed to refresh token" }, 500);
    }

    const data = await res.json();
    return c.json(data);
});

const port = 3000;
console.log(`Server is running on http://localhost:${port}`);

serve({
    fetch: app.fetch,
    port,
});
