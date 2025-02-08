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
import 'chat_time_seperator.dart';

class ChatHistory extends ConsumerWidget {
  final Room _room;

  const ChatHistory({required Room room, super.key}) : _room = room;

  Message? _getPreviousMessage(List<Message> messages, int index) {
    while (true) {
      index++;
      if (index > messages.length) return null;
      final message = messages[index];
      if (message.parentId == null) return message;
    }
  }

  Message? _getNextMessage(List<Message> messages, int index) {
    while (true) {
      index--;
      if (index < 0) return null;
      final message = messages[index];
      if (message.parentId == null) return message;
    }
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

              MessageStackPosition stackPosition = MessageStackPosition.bottom;
              final previousMessage = _getPreviousMessage(items, index);
              final nextMessage = _getNextMessage(items, index);

              final isNewDayToPreviousMessage =
                  previousMessage == null || !previousMessage.created.isSameDayAs(item.created);
              final isNewDayToNextMessage = nextMessage == null || !nextMessage.created.isSameDayAs(item.created);
              final isNewAuthorToPreviousMessage = previousMessage == null || previousMessage.personId != item.personId;
              final isNewAuthorToNextMessage = nextMessage == null || nextMessage.personId != item.personId;
              final isTimeGapToPreviousMessage =
                  previousMessage != null && item.created.difference(previousMessage.created).inMinutes > 5;
              final isTimeGapToNextMessage =
                  nextMessage == null || nextMessage.created.difference(item.created).inMinutes > 5;

              bool isDetachedFromPreviousMessage = false;
              bool isDetachedFromNextMessage = true;
              if (previousMessage != null) {
                if (!isNewDayToPreviousMessage && !isNewAuthorToPreviousMessage && isTimeGapToPreviousMessage) {
                  isDetachedFromPreviousMessage = true;
                }
              }
              if (nextMessage != null) {
                if (!isNewDayToNextMessage && !isNewAuthorToNextMessage && !isTimeGapToNextMessage) {
                  isDetachedFromNextMessage = false;
                }
              }

              if (isDetachedFromPreviousMessage) {
                if (isDetachedFromNextMessage) {
                  stackPosition = MessageStackPosition.single;
                } else {
                  stackPosition = MessageStackPosition.top;
                }
              } else if (isDetachedFromNextMessage) {
                stackPosition = MessageStackPosition.bottom;
              }

              final widgets = <Widget>[];

              if (isNewDayToPreviousMessage) widgets.add(ChatTimeSeparator(dateTime: item.created));
              if (isNewDayToPreviousMessage || isNewAuthorToPreviousMessage) {
                widgets.add(
                  Skeletonizer(
                    enabled: !ref.watch(personProvider(item.personId)).hasValue,
                    child: PersonMessageAnnotation(
                      person: ref.watch(personProvider(item.personId)).hasValue
                          ? ref.watch(personProvider(item.personId)).value!
                          : Person.placeholder(),
                    ),
                  ),
                );
              }

              widgets.add(
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChatMessage(
                    message: item,
                    stackPosition: stackPosition,
                    isShowingTime: true,
                  ),
                ),
              );

              if (isDetachedFromNextMessage) widgets.add(const SizedBox(height: 8));

              if (widgets.length > 1) return Column(children: widgets);
              return widgets.first;
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
