// api_client.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webex_chat/src/core/webex_sdk/api_request_exception.dart';
import 'package:webex_chat/src/core/webex_sdk/api_response.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_identity.dart'; // For JSON handling

class APIClient {
  final String _baseUrl;
  final http.Client _client;
  final WebexIdentity? _identity;

  APIClient({required String baseUrl, WebexIdentity? identity})
      : _baseUrl = baseUrl,
        _client = http.Client(),
        _identity = identity;

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    return await _makeRequest('get', path, headers: headers);
  }

  Future<ApiResponse> post(
    String path,
    dynamic body, {
    BodyType bodyType = BodyType.json,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest('post', path, body: body, bodyType: bodyType, headers: headers);
  }

  Future<ApiResponse> put(String path, dynamic body, {Map<String, String>? headers}) async {
    return await _makeRequest('put', path, body: body, headers: headers);
  }

  Future<ApiResponse> delete(String path, {Map<String, String>? headers}) async {
    return await _makeRequest('delete', path, headers: headers);
  }

  Future<ApiResponse> _makeRequest(
    String method,
    String path, {
    dynamic body,
    BodyType bodyType = BodyType.json,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse('$_baseUrl$path');
    final Map<String, String> allHeaders = headers ?? {};

    // Prepare the body
    dynamic bodyData;
    if (body != null) {
      bodyData = _prepareBody(body, bodyType);

      // Set the content type
      switch (bodyType) {
        case BodyType.json:
          allHeaders['Content-Type'] = 'application/json';
          break;
        case BodyType.formData:
          allHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
          break;
      }
    }

    if (_identity != null) {
      allHeaders['Authorization'] = 'Bearer ${await _identity.getValidAccessToken()}';
    }

    http.Response response;
    switch (method) {
      case 'get':
        response = await _client.get(uri, headers: allHeaders);
        break;
      case 'post':
        response = await _client.post(uri, body: bodyData, headers: allHeaders);
        break;
      case 'put':
        response = await _client.put(uri, body: bodyData, headers: allHeaders);
        break;
      case 'delete':
        response = await _client.delete(uri, headers: allHeaders);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successful response
      return ApiResponse(response);
    } else {
      // Handle error responses
      throw ApiRequestException(
        'API request failed: ${response.statusCode} ${uri.path} - ${response.body}',
        response: response,
        uri: uri,
        body: bodyData,
      );
    }
  }

  String _prepareBody(dynamic body, BodyType bodyType) {
    switch (bodyType) {
      case BodyType.json:
        return jsonEncode(body);
      case BodyType.formData:
        body as Map<String, dynamic>;
        final List<String> bodyParts = [];
        body.forEach((key, value) {
          bodyParts.add('$key=${Uri.encodeQueryComponent(value.toString())}');
        });
        return bodyParts.join('&');
    }
  }
}

enum BodyType { json, formData }
