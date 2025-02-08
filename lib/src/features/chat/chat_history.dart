import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webex_chat/src/core/extensions/date_time_extensions.dart';
import 'package:webex_chat/src/core/models/message.dart';
import 'package:webex_chat/src/core/models/room.dart';
import 'package:webex_chat/src/features/chat/chat_providers.dart';
import 'package:webex_chat/src/features/person/person_message_annotation.dart';
import 'package:webex_chat/src/features/person/person_provider.dart';

import '../../core/models/person.dart';
import 'chat_message.dart';
import 'chat_message_flow.dart';
import 'chat_time_seperator.dart';

class ChatHistory extends ConsumerWidget {
  final Room _room;

  const ChatHistory({required Room room, super.key}) : _room = room;

  List<Message> _getThreadForMessage(List<Message> messages, Message message) {
    return messages.where((m) => m.parentId == message.id).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(paginatedMessagesProvider(_room));
    final messagesAsyncNotifier = ref.watch(paginatedMessagesProvider(_room).notifier);

    return messagesAsync.when(
      data: (items) => AnimatedPrimaryScrollController(
        animationFactory: const ChromiumEaseInOut(),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: items.length + (messagesAsyncNotifier.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              final item = items[index];

              if (item.parentId != null) {
                return const SizedBox.shrink();
              }

              final previousMessage = ChatMessageFlow.getPreviousMessage(items, index);
              final nextMessage = ChatMessageFlow.getNextMessage(items, index);
              final threadMessages = _getThreadForMessage(items, item);
              final isPreviousMessageAThread =
                  previousMessage != null ? items.any((m) => m.parentId == previousMessage.id) : false;

              return ChatMessageFlow(
                message: item,
                previousMessage: previousMessage,
                nextMessage: nextMessage,
                threadMessages: threadMessages,
                isPreviousMessageAThread: isPreviousMessageAThread,
              );
            } else if (messagesAsyncNotifier.hasMore) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                messagesAsyncNotifier.loadMore();
              });
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("No more messages"));
            }
          },
        ),
      ),
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
