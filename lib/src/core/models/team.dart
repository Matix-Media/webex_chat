import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
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

  ColorScheme get colorScheme {
    // Generate SHA-256 hash
    var bytes = utf8.encode(id);
    var digest = sha256.convert(bytes);
    var hexColor = '#${digest.toString().substring(0, 6)}';

    // Convert hex to Color
    final color = Color(int.parse(hexColor.substring(1, 7), radix: 16));

    // Generate ColorScheme
    return ColorScheme.fromSeed(seedColor: color);
  }

  /// Helper methods for genericArgumentFactories
  static Team fromJsonModel(Object? json) => Team.fromJson(json as Map<String, dynamic>);

  static Map<String, dynamic> toJsonModel(Team team) => team.toJson();

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();
}
