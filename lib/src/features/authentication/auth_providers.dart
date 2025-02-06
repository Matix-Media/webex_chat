import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/identity_storage.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/secure_identity_storage.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_auth.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_identity.dart';

import '../../core/webex_sdk/webex_api.dart';

final identityStorageProvider = Provider<IdentityStorage>((ref) => SecureIdentityStorage());

final webexAuthProvider = Provider<WebexAuth>((ref) => WebexAuth());

final identityProvider = StateProvider<WebexIdentity?>((ref) => null);

final webexApiProvider = Provider<WebexAPI>(
  (ref) => WebexAPI(identity: ref.watch(identityProvider)),
);
