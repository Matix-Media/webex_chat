import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/identity_storage.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_identity.dart';

class SecureIdentityStorage implements IdentityStorage {
  static const _key = "identity";
  final _logger = Logger("SecureIdentityStorage");
  final storage = FlutterSecureStorage();

  @override
  Future<void> deleteIdentity() async {
    await storage.delete(key: _key);
  }

  @override
  Future<WebexIdentity?> getIdentity() async {
    final json = await storage.read(key: 'token');
    if (json == null) return null;
    try {
      return WebexIdentity.fromJson(jsonDecode(json));
    } catch (e) {
      _logger.severe("Failed to parse identity", e);
      return null;
    }
  }

  @override
  Future<void> saveIdentity(WebexIdentity identity) async {
    final json = jsonEncode(identity);
    await storage.write(key: 'token', value: json);
  }
}
