import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/features/teams/teams_providers.dart';

class TeamsList extends ConsumerWidget {
  const TeamsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(paginatedTeamsProvider);
    final teamsAsyncNotifier = ref.watch(paginatedTeamsProvider.notifier);

    return teamsAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length + (teamsAsyncNotifier.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return ListTile(title: Text(item.name));
          } else if (teamsAsyncNotifier.hasMore) {
            teamsAsyncNotifier.loadMore();
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("No more teams"));
          }
        },
      ),
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
