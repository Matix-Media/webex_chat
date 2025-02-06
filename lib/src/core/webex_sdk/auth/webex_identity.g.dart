// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webex_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebexIdentity _$WebexIdentityFromJson(Map<String, dynamic> json) =>
    WebexIdentity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
      refreshExpiration: DateTime.parse(json['refreshExpiration'] as String),
    );

Map<String, dynamic> _$WebexIdentityToJson(WebexIdentity instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiration': instance.expiration.toIso8601String(),
      'refreshExpiration': instance.refreshExpiration.toIso8601String(),
    };
