import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/team.dart';
import 'package:webex_chat/src/features/rooms/rooms_providers.dart';

import '../../core/models/room.dart';

class RoomsList extends ConsumerWidget {
  final Team? _team;
  final Function(Room) _onRoomSelected;

  const RoomsList({Team? forTeam, required Function(Room room) onRoomSelected, super.key})
      : _team = forTeam,
        _onRoomSelected = onRoomSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync =
        _team != null ? ref.watch(paginatedRoomsByTeamProvider(_team)) : ref.watch(paginatedRoomsProvider);
    final roomsAsyncNotifier = _team != null
        ? ref.watch(paginatedRoomsByTeamProvider(_team).notifier)
        : ref.watch(paginatedRoomsProvider.notifier);

    return roomsAsync.when(
      data: (items) => ListView.builder(
          itemCount: items.length + (roomsAsyncNotifier.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              final item = items[index];
              return ListTile(
                leading: Icon(Icons.forum),
                title: Text(
                  item.id == _team?.id ? "General" : item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () => _onRoomSelected(item),
              );
            } else if (roomsAsyncNotifier.hasMore) {
              roomsAsyncNotifier.loadMore();
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("No more rooms"));
            }
          }),
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
