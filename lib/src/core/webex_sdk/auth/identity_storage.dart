import 'package:webex_chat/src/core/webex_sdk/auth/webex_identity.dart';

abstract class IdentityStorage {
  Future<WebexIdentity?> getIdentity();

  Future<void> saveIdentity(WebexIdentity identity);

  Future<void> deleteIdentity();
}
