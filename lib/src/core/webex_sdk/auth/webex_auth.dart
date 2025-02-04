import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/webex_sdk/webex_api.dart';

import 'device_code_response.dart';
import 'webex_identity.dart';
import '../webex_config.dart';
import 'auth_exception.dart';

class WebexAuth {
  final _logger = Logger('WebexAuth');
  final _webexAPI = WebexAPI();
  late final WebexConfig _config;
  DeviceCodeResponse? _deviceCodeResponse;

  WebexAuth({required WebexConfig config}) {
    _config = config;
  }

  Future<void> requestDeviceCode() async {
    _logger.info('Requesting device code');
    final res = await _webexAPI.getDeviceCode(
      clientId: _config.clientId,
      scopes: _config.scopes,
    );
    _deviceCodeResponse = res;
    _logger.info('Device code response: ${res.toJson()}');
  }

  Future<WebexIdentity> pollDeviceToken() async {
    if (_deviceCodeResponse == null) {
      _logger.severe('Device code response is null');
      throw AuthException('No device code requested');
    }
    _logger.info('Polling device token');
    final res = await _webexAPI.getDeviceToken(
        clientId: _config.clientId,
        clientSecret: _config.clientSecret,
        deviceCode: _deviceCodeResponse!.deviceCode);

    return WebexIdentity(
      config: _config,
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
      expiration: DateTime.now().add(Duration(seconds: res.expiresIn)),
      refreshExpiration:
          DateTime.now().add(Duration(seconds: res.refreshTokenExpiresIn)),
    );
  }

  Future<void> loadFromStorage() async {}
}
