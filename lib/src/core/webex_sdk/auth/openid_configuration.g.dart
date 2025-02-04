// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openid_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenIdConfiguration _$OpenIdConfigurationFromJson(Map<String, dynamic> json) =>
    OpenIdConfiguration(
      issuer: json['issuer'] as String,
      authorizationEndpoint: json['authorization_endpoint'] as String,
      tokenEndpoint: json['token_endpoint'] as String,
      userinfoEndpoint: json['userinfo_endpoint'] as String,
      jwksUri: json['jwks_uri'] as String,
      responseTypesSupported:
          (json['response_types_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      subjectTypesSupported: (json['subject_types_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      idTokenSigningAlgValuesSupported:
          (json['id_token_signing_alg_values_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      scopesSupported: (json['scopes_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      claimsSupported: (json['claims_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      grantTypesSupported: (json['grant_types_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requestParameterSupported: json['request_parameter_supported'] as bool,
      requestUriParameterSupported:
          json['request_uri_parameter_supported'] as bool,
      tokenEndpointAuthMethodsSupported:
          (json['token_endpoint_auth_methods_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      codeChallengeMethodsSupported:
          (json['code_challenge_methods_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$OpenIdConfigurationToJson(
        OpenIdConfiguration instance) =>
    <String, dynamic>{
      'issuer': instance.issuer,
      'authorization_endpoint': instance.authorizationEndpoint,
      'token_endpoint': instance.tokenEndpoint,
      'userinfo_endpoint': instance.userinfoEndpoint,
      'jwks_uri': instance.jwksUri,
      'response_types_supported': instance.responseTypesSupported,
      'subject_types_supported': instance.subjectTypesSupported,
      'id_token_signing_alg_values_supported':
          instance.idTokenSigningAlgValuesSupported,
      'scopes_supported': instance.scopesSupported,
      'claims_supported': instance.claimsSupported,
      'grant_types_supported': instance.grantTypesSupported,
      'request_parameter_supported': instance.requestParameterSupported,
      'request_uri_parameter_supported': instance.requestUriParameterSupported,
      'token_endpoint_auth_methods_supported':
          instance.tokenEndpointAuthMethodsSupported,
      'code_challenge_methods_supported':
          instance.codeChallengeMethodsSupported,
    };
