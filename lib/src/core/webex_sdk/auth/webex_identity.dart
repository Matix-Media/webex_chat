import 'package:json_annotation/json_annotation.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/idbroker_api.dart';

part 'webex_identity.g.dart';

@JsonSerializable()
class WebexIdentity {
  @JsonKey(name: 'access_token')
  late String _accessToken;
  @JsonKey(name: 'refresh_token')
  late String _refreshToken;
  @JsonKey(
      name: 'expires_in',
      fromJson: _dateTimeFromMilliseconds,
      toJson: _dateTimeToMilliseconds)
  late DateTime _expiration;
  @JsonKey(
      name: 'refresh_token_expires_in',
      fromJson: _dateTimeFromMilliseconds,
      toJson: _dateTimeToMilliseconds)
  late DateTime _refreshExpiration;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  DateTime get expiration => _expiration;

  DateTime get refreshExpiration => _refreshExpiration;

  bool get isExpired =>
      expiration.isBefore(DateTime.now().add(Duration(seconds: 5)));

  bool get isRefreshExpired =>
      refreshExpiration.isBefore(DateTime.now().add(Duration(seconds: 5)));

  WebexIdentity({
    required String accessToken,
    required String refreshToken,
    required DateTime expiration,
    required DateTime refreshExpiration,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiration = expiration;
    _refreshExpiration = refreshExpiration;
  }

  factory WebexIdentity.fromJson(Map<String, dynamic> json) =>
      _$WebexIdentityFromJson(json);

  Map<String, dynamic> toJson() => _$WebexIdentityToJson(this);

  Future<String> getValidAccessToken() async {
    if (isExpired) {
      await refresh();
    }
    return _accessToken;
  }

  Future<void> refresh() async {
    final response = await IDBrokerAPI().refreshAccessToken(
      refreshToken: _refreshToken,
    );
    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _expiration = DateTime.now().add(Duration(seconds: response.expiresIn));
    _refreshExpiration =
        DateTime.now().add(Duration(seconds: response.refreshTokenExpiresIn));
  }

  static DateTime _dateTimeFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int _dateTimeToMilliseconds(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;
}
