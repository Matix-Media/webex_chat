import 'webex_config.dart';

class WebexClient {
  late final WebexConfig _config;

  WebexClient({required WebexConfig config}) {
    _config = config;
  }
}