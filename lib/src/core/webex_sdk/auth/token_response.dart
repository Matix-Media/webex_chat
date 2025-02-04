import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final String scope;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token_expires_in')
  final int refreshTokenExpiresIn;

  TokenResponse({
    required this.scope,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.accessToken,
    required this.refreshTokenExpiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}
