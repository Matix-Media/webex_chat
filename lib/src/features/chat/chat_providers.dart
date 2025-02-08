import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/message.dart';
import 'package:webex_chat/src/core/models/room.dart';
import 'package:webex_chat/src/core/webex_sdk/paginated_items_notifier.dart';
import 'package:webex_chat/src/features/authentication/auth_providers.dart';

import '../person/person_provider.dart';

final paginatedMessagesProvider =
    StateNotifierProvider.family<PaginatedItemsNotifier<Message>, AsyncValue<List<Message>>, Room>((ref, room) {
  final getMessages = ref.watch(webexApiProvider).getMessages;
  final fetchPeople = ref.watch(peopleCacheProvider.notifier).fetchAndCachePeople;
  return PaginatedItemsNotifier(({String? cursor}) async {
    final messages = await getMessages(roomId: room.id, cursor: cursor);
    await fetchPeople(messages.items.map((message) => message.personId).toList());
    return messages;
  });
});
