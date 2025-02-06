import 'dart:async';

import 'package:logging/logging.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webex_chat/src/core/webex_sdk/api_request_exception.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_auth.dart';

import '../../core/transitions.dart';
import '../../ui/screens/overview_screen.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _logger = Logger("LoginScreen");
  bool _isLoadingDeviceCode = true;
  bool _isPollingDeviceToken = false;
  final _webexAuth = WebexAuth();
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _webexAuth.requestDeviceCode();
      if (mounted && _webexAuth.deviceCodeResponse != null) {
        _logger.info("Polling for device token every ${_webexAuth.deviceCodeResponse!.interval} + 0.5 seconds");
        _pollTimer = Timer.periodic(
          Duration(milliseconds: (_webexAuth.deviceCodeResponse!.interval * 1000) + 500),
          (timer) async {
            if (_isPollingDeviceToken) return;
            if (mounted) setState(() => _isPollingDeviceToken = true);
            try {
              final res = await _webexAuth.pollDeviceToken();
              await ref.read(identityStorageProvider).saveIdentity(res);
              ref.read(identityProvider.notifier).state = res;
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                fadeRoute(const OverviewScreen()),
              );
            } catch (e) {
              if (e is! ApiRequestException) rethrow;
              // 428 - Precondition Required
              if (e.response?.statusCode != 428) rethrow;
            }
            if (mounted) setState(() => _isPollingDeviceToken = false);
          },
        );
        setState(() {
          _isLoadingDeviceCode = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card.filled(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: SizedBox(
            width: 472,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: _isPollingDeviceToken ? null : 0,
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Scan the QR-Code with your phone or click on the link below.",
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                                onPressed: () {
                                  if (_webexAuth.deviceCodeResponse == null) return;
                                  launchUrl(
                                    Uri.parse(
                                      _webexAuth.deviceCodeResponse!.verificationUriComplete,
                                    ),
                                  );
                                },
                                child: Text("Login via Browser"))
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: AnimatedCrossFade(
                          firstChild: Center(child: CircularProgressIndicator()),
                          secondChild: Center(
                            child: QrImageView(
                              data: _webexAuth.deviceCodeResponse?.verificationUriComplete ?? "",
                              size: 180,
                              version: QrVersions.auto,
                            ),
                          ),
                          crossFadeState: _isLoadingDeviceCode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
