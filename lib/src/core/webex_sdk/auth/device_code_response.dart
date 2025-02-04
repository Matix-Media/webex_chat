import 'package:json_annotation/json_annotation.dart';

part 'device_code_response.g.dart';

@JsonSerializable()
class DeviceCodeResponse {
  @JsonKey(name: 'device_code')
  final String deviceCode;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'user_code')
  final String userCode;
  @JsonKey(name: 'verification_uri')
  final String verificationUri;
  @JsonKey(name: 'verification_uri_complete')
  final String verificationUriComplete;
  @JsonKey(name: 'interval')
  final int interval;

  DeviceCodeResponse({
    required this.deviceCode,
    required this.expiresIn,
    required this.userCode,
    required this.verificationUri,
    required this.verificationUriComplete,
    required this.interval,
  });

  factory DeviceCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCodeResponseToJson(this);
}
