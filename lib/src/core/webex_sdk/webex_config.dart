class WebexConfig {
  static const String webexApiBaseUrl = 'https://webexapis.com/v1';

  late final String _clientId;
  late final String _clientSecret;
  late final String _redirectUri;
  late final List<String> _scopes;
  late final String _encryptionKey;

  String get clientId => _clientId;

  String get clientSecret => _clientSecret;

  String get redirectUri => _redirectUri;

  List<String> get scopes => _scopes;

  String get encryptionKey => _encryptionKey;

  WebexConfig({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    required List<String> scopes,
    required String encryptionKey,
  }) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _redirectUri = redirectUri;
    _scopes = scopes;
    if (!_scopes.contains('spark:all')) {
      _scopes.add('spark:all');
    }
    _encryptionKey = encryptionKey;
  }
}
