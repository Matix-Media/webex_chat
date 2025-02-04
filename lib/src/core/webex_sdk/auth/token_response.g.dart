// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      scope: json['scope'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      tokenType: json['token_type'] as String,
      refreshToken: json['refresh_token'] as String,
      accessToken: json['access_token'] as String,
      refreshTokenExpiresIn: (json['refresh_token_expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'access_token': instance.accessToken,
      'refresh_token_expires_in': instance.refreshTokenExpiresIn,
    };
