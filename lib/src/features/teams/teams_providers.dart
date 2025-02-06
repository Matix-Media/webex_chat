import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/team.dart';
import 'package:webex_chat/src/core/webex_sdk/paginated_items_notifier.dart';

import '../authentication/auth_providers.dart';

final fetchTeamsProvider = FutureProvider((ref) async {
  final webexApi = ref.watch(webexApiProvider);
  final teams = await webexApi.getTeams();
  return teams;
});

final paginatedTeamsProvider = StateNotifierProvider<PaginatedItemsNotifier<Team>, AsyncValue<List<Team>>>(
  (ref) => PaginatedItemsNotifier(ref.watch(webexApiProvider).getTeams),
);
