import 'package:json_annotation/json_annotation.dart';
import 'package:webex_chat/src/core/webex_sdk/api_response.dart';
import 'package:collection/collection.dart';

part "paginated_response.g.dart";

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  @JsonKey(name: "items")
  final List<T> items;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? nextCursor;

  PaginatedResponse({
    required this.items,
    this.nextCursor,
  });

  factory PaginatedResponse.fromResponse(ApiResponse response, T Function(Object? json) fromJsonT, String cursorName) {
    return PaginatedResponse.fromJson(
      response.body,
      fromJsonT,
      nextCursor: PaginatedResponse.getNextCursorFromWebLinking(response, cursorName),
    );
  }

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT,
      {String? nextCursor}) {
    final serialized = _$PaginatedResponseFromJson(json, fromJsonT);
    return PaginatedResponse(
      items: serialized.items,
      nextCursor: nextCursor,
    );
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$PaginatedResponseToJson(this, toJsonT);

  static String? getNextCursorFromWebLinking(ApiResponse response, String cursorName) {
    if (response.headers['link'] == null) return null;
    final link = response.headers['link']!.firstWhereOrNull((link) => link.contains('>; rel="next"'));
    if (link == null) return null;

    final regex = RegExp(r'<(.*)>');
    final match = regex.firstMatch(link);
    if (match == null) return null;
    if (match.group(1) == null) return null;
    final uri = Uri.parse(match.group(1)!);
    return uri.queryParameters[cursorName];
  }
}
