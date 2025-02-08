import 'package:json_annotation/json_annotation.dart';

part "person.g.dart";

@JsonSerializable()
class Person {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'emails')
  final List<String> emails;
  @JsonKey(name: 'displayName')
  final String displayName;
  @JsonKey(name: 'nickName')
  final String nickName;
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;
  @JsonKey(name: 'userName')
  final String userName;
  @JsonKey(name: 'avatar')
  final String? avatar;
  @JsonKey(name: 'orgId')
  final String orgId;
  @JsonKey(name: 'created')
  final DateTime created;
  @JsonKey(name: 'lastModified')
  final DateTime lastModified;
  @JsonKey(name: 'type')
  final String type;

  Person({
    required this.id,
    required this.emails,
    required this.displayName,
    required this.nickName,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.avatar,
    required this.orgId,
    required this.created,
    required this.lastModified,
    required this.type,
  });

  factory Person.placeholder() => Person(
        id: '',
        emails: [],
        displayName: 'Unknown',
        nickName: 'Unknown',
        firstName: 'Unknown',
        lastName: 'Unknown',
        userName: 'Unknown',
        avatar: null,
        orgId: '',
        created: DateTime.now(),
        lastModified: DateTime.now(),
        type: 'Unknown',
      );

  /// Helper methods for genericArgumentFactories
  static Person fromJsonModel(Object? json) => Person.fromJson(json as Map<String, dynamic>);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
