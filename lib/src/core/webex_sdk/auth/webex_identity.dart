import 'package:webex_chat/src/core/webex_sdk/webex_api.dart';

import '../webex_config.dart';
import 'auth_exception.dart';

class WebexIdentity {
  late final WebexConfig _config;
  late String _accessToken;
  late String _refreshToken;
  late DateTime _expiration;
  late DateTime _refreshExpiration;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  DateTime get expiration => _expiration;

  DateTime get refreshExpiration => _refreshExpiration;

  bool get isExpired => expiration.isBefore(DateTime.now());

  bool get isRefreshExpired => refreshExpiration.isBefore(DateTime.now());

  WebexIdentity({
    required WebexConfig config,
    required String accessToken,
    required String refreshToken,
    required DateTime expiration,
    required DateTime refreshExpiration,
  }) {
    _config = config;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiration = expiration;
    _refreshExpiration = refreshExpiration;
  }

  Future<String> getValidAccessToken() async {
    if (isExpired) {
      await refresh();
    }
    return _accessToken;
  }

  Future<void> refresh() async {
    final response = await WebexAPI().refreshAccessToken(
      clientId: _config.clientId,
      clientSecret: _config.clientSecret,
      refreshToken: _refreshToken,
    );
    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _expiration = DateTime.now().add(Duration(seconds: response.expiresIn));
    _refreshExpiration =
        DateTime.now().add(Duration(seconds: response.refreshTokenExpiresIn));
  }
}
