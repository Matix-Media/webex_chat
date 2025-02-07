import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'isLocked')
  final bool isLocked;
  @JsonKey(name: 'lastActivity')
  final DateTime lastActivity;
  @JsonKey(name: 'creatorId')
  final String creatorId;
  @JsonKey(name: 'created')
  final DateTime created;
  @JsonKey(name: 'ownerId')
  final String? ownerId;
  @JsonKey(name: 'teamId')
  final String? teamId;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;

  Room({
    required this.id,
    required this.title,
    required this.type,
    required this.isLocked,
    required this.lastActivity,
    required this.creatorId,
    required this.created,
    this.ownerId,
    this.teamId,
    this.description,
    required this.isPublic,
    required this.isReadOnly,
  });

  /// Helper methods for genericArgumentFactories
  static Room fromJsonModel(Object? json) => Room.fromJson(json as Map<String, dynamic>);

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
