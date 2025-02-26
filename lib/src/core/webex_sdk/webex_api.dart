import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/models/person.dart';
import 'package:webex_chat/src/core/webex_sdk/models/paginated_response.dart';
import 'dart:convert';
import '../models/message.dart';
import '../models/room.dart';
import '../models/team.dart';
import 'auth/device_code_response.dart';
import 'auth/openid_configuration.dart';
import 'auth/token_response.dart';
import 'api_client.dart';
import 'auth/webex_identity.dart';
import 'webex_config.dart';

class WebexAPI {
  static const maxPeoplePerRequest = 85;

  final Logger _logger = Logger('WebexAPI');
  final APIClient _apiClient = APIClient(baseUrl: WebexConfig.webexApiBaseUrl);
  late final APIClient _apiClientWithIdentity;

  WebexAPI({WebexIdentity? identity}) {
    if (identity != null) {
      _apiClientWithIdentity = APIClient(
        baseUrl: WebexConfig.webexApiBaseUrl,
        identity: identity,
      );
    }
  }

  Future<OpenIdConfiguration> getOpenIdConfiguration() async {
    try {
      final response = await _apiClient.get('/.well-known/openid-configuration');
      if (response.body != null && response.body is Map<String, dynamic>) {
        return OpenIdConfiguration.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for openid configuration');
      }
    } catch (e, s) {
      _logger.severe('Error fetching openid configuration: $e', e, s);
      rethrow;
    }
  }

  Future<DeviceCodeResponse> getDeviceCode({required String clientId, required List<String> scopes}) async {
    try {
      final response = await _apiClient.post(
        '/device/authorize',
        {
          'client_id': clientId,
          'scope': scopes.join(' '),
        },
        bodyType: BodyType.formData,
      );
      if (response.body != null && response.body is Map<String, dynamic>) {
        return DeviceCodeResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device code');
      }
    } catch (e, s) {
      _logger.severe('Error fetching device code: $e', e, s);
      rethrow;
    }
  }

  Future<TokenResponse> getDeviceToken(
      {required String clientId, required String clientSecret, required String deviceCode}) async {
    try {
      final response = await _apiClient.post(
        '/device/token',
        {
          'client_id': clientId,
          'device_code': deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
        bodyType: BodyType.formData,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        },
      );
      if (response.body != null && response.body is Map<String, dynamic>) {
        return TokenResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device token');
      }
    } catch (e, s) {
      _logger.severe('Error fetching device token: $e', e, s);
      rethrow;
    }
  }

  Future<TokenResponse> refreshAccessToken({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    try {
      final response = await _apiClientWithIdentity.post(
        '/access_token',
        {
          'client_id': clientId,
          'client_secret': clientSecret,
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
        bodyType: BodyType.formData,
      );
      if (response.body != null && response.body is Map<String, dynamic>) {
        return TokenResponse.fromJson(response.body);
      } else {
        throw Exception('Invalid JSON response for device token');
      }
    } catch (e, s) {
      _logger.severe('Error fetching device token: $e', e, s);
      rethrow;
    }
  }

  Future<PaginatedResponse<Team>> getTeams({String? cursor}) async {
    try {
      final response = await _apiClientWithIdentity.get('/teams?after=$cursor');
      if (response.body != null && response.body is Map<String, dynamic>) {
        return PaginatedResponse.fromResponse(response, Team.fromJsonModel, "after");
      } else {
        throw Exception('Invalid JSON response for teams');
      }
    } catch (e, s) {
      _logger.severe('Error fetching teams: $e', e, s);
      rethrow;
    }
  }

  Future<PaginatedResponse<Room>> getRooms({String? teamId, bool orgPublicSpaces = false, String? cursor}) async {
    try {
      final params = <String, String>{"orgPublicSpaces": orgPublicSpaces ? "true" : "false"};
      if (teamId != null) params["teamId"] = teamId;
      if (cursor != null) params["cursor"] = cursor;
      final response = await _apiClientWithIdentity.get('/rooms', params: params);
      if (response.body != null && response.body is Map<String, dynamic>) {
        return PaginatedResponse.fromResponse(response, Room.fromJsonModel, "after");
      } else {
        throw Exception('Invalid JSON response for rooms');
      }
    } catch (e, s) {
      _logger.severe('Error fetching rooms: $e', e, s);
      rethrow;
    }
  }

  Future<PaginatedResponse<Message>> getMessages({required String roomId, String? cursor}) async {
    try {
      final params = <String, String>{'roomId': roomId};
      if (cursor != null) params['beforeMessage'] = cursor;
      final response = await _apiClientWithIdentity.get("/messages", params: params);
      if (response.body != null && response.body is Map<String, dynamic>) {
        return PaginatedResponse.fromResponse(response, Message.fromJsonModel, "beforeMessage");
      } else {
        throw Exception('Invalid JSON response for messages');
      }
    } catch (e, s) {
      _logger.severe('Error fetching messages: $e', e, s);
      rethrow;
    }
  }

  Future<PaginatedResponse<Person>> getPeople({required List<String> peopleIds}) async {
    try {
      assert(peopleIds.length <= maxPeoplePerRequest);
      final response = await _apiClientWithIdentity.get("/people", params: {"id": peopleIds.join(",")});
      if (response.body != null && response.body is Map<String, dynamic>) {
        return PaginatedResponse.fromResponse(response, Person.fromJsonModel, "after");
      } else {
        throw Exception('Invalid JSON response for persons (webex-people-api)');
      }
    } catch (e, s) {
      _logger.severe("Error fetching messages: $e", e, s);
      rethrow;
    }
  }
}
