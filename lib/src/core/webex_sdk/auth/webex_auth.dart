import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/identity_storage.dart';
import 'idbroker_api.dart';
import 'device_code_response.dart';
import 'webex_identity.dart';
import 'auth_exception.dart';

class WebexAuth {
  final _logger = Logger('WebexAuth');
  final _idBrokerAPI = IDBrokerAPI();
  DeviceCodeResponse? _deviceCodeResponse;

  DeviceCodeResponse? get deviceCodeResponse => _deviceCodeResponse;

  Future<void> requestDeviceCode() async {
    final res = await _idBrokerAPI.getDeviceCode();
    _deviceCodeResponse = res;
  }

  Future<WebexIdentity> pollDeviceToken() async {
    if (_deviceCodeResponse == null) {
      _logger.severe('Device code response is null');
      throw AuthException('No device code requested');
    }
    final res = await _idBrokerAPI.getDeviceToken(
      deviceCode: _deviceCodeResponse!.deviceCode,
    );

    return WebexIdentity(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
      expiration: DateTime.now().add(Duration(seconds: res.expiresIn)),
      refreshExpiration: DateTime.now().add(Duration(seconds: res.refreshTokenExpiresIn)),
    );
  }
}
