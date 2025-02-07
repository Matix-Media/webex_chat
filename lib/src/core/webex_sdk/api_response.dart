import 'dart:convert';

import 'package:http/http.dart';

class ApiResponse {
  late final dynamic body;
  late final Map<String, List<String>> headers;
  late final int statusCode;

  ApiResponse(Response response) {
    headers = response.headersSplitValues;
    statusCode = response.statusCode;
    final contentType = response.headers['content-type'];
    if (contentType != null && contentType.contains('application/json')) {
      body = jsonDecode(utf8.decode(response.bodyBytes)); // Parse JSON
    } else {
      body = response.body; // Return raw body (e.g., for text responses)
    }
  }

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
