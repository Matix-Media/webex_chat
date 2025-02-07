import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/team.dart';

import '../../core/models/room.dart';
import '../../core/webex_sdk/paginated_items_notifier.dart';
import '../authentication/auth_providers.dart';

final fetchRoomsProvider = FutureProvider((ref) async {
  final webexApi = ref.watch(webexApiProvider);
  final rooms = await webexApi.getRooms();
  return rooms;
});

final paginatedRoomsProvider = StateNotifierProvider<PaginatedItemsNotifier<Room>, AsyncValue<List<Room>>>(
  (ref) => PaginatedItemsNotifier(ref.watch(webexApiProvider).getRooms),
);

final paginatedRoomsByTeamProvider =
    StateNotifierProvider.family<PaginatedItemsNotifier<Room>, AsyncValue<List<Room>>, Team>((ref, team) {
  final getRooms = ref.watch(webexApiProvider).getRooms;
  return PaginatedItemsNotifier(
    ({String? cursor}) => getRooms(teamId: team.id, cursor: cursor),
  );
});
