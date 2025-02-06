import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/token_response.dart';

import '../api_client.dart';
import '../api_request_exception.dart';
import 'device_code_response.dart';

class IDBrokerAPI {
  final Logger _logger = Logger('IDBrokerAPI');
  final APIClient _apiClient = APIClient(baseUrl: "https://webex-id-broker.matix-media.net");

  Future<DeviceCodeResponse> getDeviceCode() async {
    try {
      final response = await _apiClient.get('/device/authorize');
      if (response.body != null && response.body is Map<String, dynamic>) {
        return DeviceCodeResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device code');
      }
    } catch (e) {
      _logger.severe('Error fetching device code: $e');
      rethrow;
    }
  }

  Future<TokenResponse> getDeviceToken({required String deviceCode}) async {
    try {
      final response = await _apiClient.post(
        '/device/token',
        {
          'deviceCode': deviceCode,
        },
      );
      if (response.body != null && response.body is Map<String, dynamic>) {
        return TokenResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device token');
      }
    } catch (e) {
      if (e is! ApiRequestException) rethrow;
      // 428 - Precondition Required
      if (e.response?.statusCode != 428) _logger.severe('Error fetching device token: $e');
      rethrow;
    }
  }

  Future<TokenResponse> refreshAccessToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _apiClient.post(
        '/refresh',
        {
          'refreshToken': refreshToken,
        },
      );
      if (response.body != null && response.body is Map<String, dynamic>) {
        return TokenResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device token');
      }
    } catch (e) {
      _logger.severe('Error fetching device token: $e');
      rethrow;
    }
  }
}
