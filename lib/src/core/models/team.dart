import 'package:json_annotation/json_annotation.dart';

part "team.g.dart";

@JsonSerializable()
class Team {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "creatorId")
  final String creatorId;
  @JsonKey(name: "created", fromJson: DateTime.parse, toJson: _dateTimeToJson)
  final DateTime created;

  Team({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.created,
  });

  /// Helper methods for genericArgumentFactories
  static Team fromJsonModel(Object? json) => Team.fromJson(json as Map<String, dynamic>);

  static Map<String, dynamic> toJsonModel(Team team) => team.toJson();

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();
}
