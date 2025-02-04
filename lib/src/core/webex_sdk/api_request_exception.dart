import 'package:http/http.dart';

class ApiRequestException implements Exception {
  final String message;
  final Response? response;
  final String? body;
  final Uri? uri;

  ApiRequestException(this.message, {this.response, this.body, this.uri});

  @override
  String toString() {
    return 'ApiRequestException: $message';
  }
}
