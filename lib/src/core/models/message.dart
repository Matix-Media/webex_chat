import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part "message.g.dart";

@CopyWith()
@JsonSerializable()
class Message {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'roomId')
  final String roomId;
  @JsonKey(name: 'roomType')
  final String roomType;
  @JsonKey(name: 'text')
  final String? text;
  @JsonKey(name: 'personId')
  final String personId;
  @JsonKey(name: 'personEmail')
  final String personEmail;
  @JsonKey(name: 'created')
  final DateTime created;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'meetingId')
  final String? meetingId;
  @JsonKey(name: 'html')
  final String? html;
  @JsonKey(name: 'mentionedGroups')
  final List<String>? mentionedGroups;
  @JsonKey(name: 'mentionedPeople')
  final List<String>? mentionedPeople;
  @JsonKey(name: 'updated')
  final DateTime? updated;
  @JsonKey(name: 'files')
  final List<String>? files;
  @JsonKey(name: 'isVoiceClip')
  final bool? isVoiceClip;

  Message({
    required this.id,
    required this.roomId,
    required this.roomType,
    required this.text,
    required this.personId,
    required this.personEmail,
    required this.created,
    this.parentId,
    this.meetingId,
    this.html,
    this.mentionedGroups,
    this.mentionedPeople,
    this.updated,
    this.files,
    this.isVoiceClip,
  });

  /// Helper methods for genericArgumentFactories
  static Message fromJsonModel(Object? json) => Message.fromJson(json as Map<String, dynamic>);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
