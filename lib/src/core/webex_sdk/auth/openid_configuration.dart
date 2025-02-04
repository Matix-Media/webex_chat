import 'package:json_annotation/json_annotation.dart';

part 'openid_configuration.g.dart';

@JsonSerializable()
class OpenIdConfiguration {
  @JsonKey(name: 'issuer')
  final String issuer;
  @JsonKey(name: 'authorization_endpoint')
  final String authorizationEndpoint;
  @JsonKey(name: 'token_endpoint')
  final String tokenEndpoint;
  @JsonKey(name: 'userinfo_endpoint')
  final String userinfoEndpoint;
  @JsonKey(name: 'jwks_uri')
  final String jwksUri;
  @JsonKey(name: 'response_types_supported')
  final List<String> responseTypesSupported;
  @JsonKey(name: 'subject_types_supported')
  final List<String> subjectTypesSupported;
  @JsonKey(name: 'id_token_signing_alg_values_supported')
  final List<String> idTokenSigningAlgValuesSupported;
  @JsonKey(name: 'scopes_supported')
  final List<String> scopesSupported;
  @JsonKey(name: 'claims_supported')
  final List<String> claimsSupported;
  @JsonKey(name: 'grant_types_supported')
  final List<String> grantTypesSupported;
  @JsonKey(name: 'request_parameter_supported')
  final bool requestParameterSupported;
  @JsonKey(name: 'request_uri_parameter_supported')
  final bool requestUriParameterSupported;
  @JsonKey(name: 'token_endpoint_auth_methods_supported')
  final List<String> tokenEndpointAuthMethodsSupported;
  @JsonKey(name: 'code_challenge_methods_supported')
  final List<String> codeChallengeMethodsSupported;

  OpenIdConfiguration({
    required this.issuer,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.userinfoEndpoint,
    required this.jwksUri,
    required this.responseTypesSupported,
    required this.subjectTypesSupported,
    required this.idTokenSigningAlgValuesSupported,
    required this.scopesSupported,
    required this.claimsSupported,
    required this.grantTypesSupported,
    required this.requestParameterSupported,
    required this.requestUriParameterSupported,
    required this.tokenEndpointAuthMethodsSupported,
    required this.codeChallengeMethodsSupported,
  });

  factory OpenIdConfiguration.fromJson(Map<String, dynamic> json) =>
      _$OpenIdConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$OpenIdConfigurationToJson(this);
}
