import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webex_chat/src/core/extensions/date_time_extensions.dart';

import '../../core/models/message.dart';
import '../../core/models/person.dart';
import '../person/person_message_annotation.dart';
import '../person/person_provider.dart';
import 'chat_message.dart';
import 'chat_time_seperator.dart';

class ChatMessageFlow extends ConsumerWidget {
  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;
  final List<Message>? threadMessages;
  final bool isPreviousMessageAThread;
  final bool isNeverShowingTimeSeperator;
  final bool isNeverShowingAuthor;
  late final MessageStackPosition stackPosition;
  late final bool isNewDayToPreviousMessage;
  late final bool isNewDayToNextMessage;
  late final bool isNewAuthorToPreviousMessage;
  late final bool isNewAuthorToNextMessage;
  late final bool isTimeGapToPreviousMessage;
  late final bool isTimeGapToNextMessage;
  late final bool isDetachedFromPreviousMessage;
  late final bool isDetachedFromNextMessage;

  bool get hasThread => threadMessages?.isNotEmpty ?? false;

  ChatMessageFlow({
    super.key,
    required this.message,
    this.previousMessage,
    this.nextMessage,
    this.threadMessages,
    this.isPreviousMessageAThread = false,
    this.isNeverShowingTimeSeperator = false,
    this.isNeverShowingAuthor = false,
  }) {
    MessageStackPosition tempStackPosition = MessageStackPosition.bottom;

    isNewDayToPreviousMessage = previousMessage == null || !previousMessage!.created.isSameDayAs(message.created);
    isNewDayToNextMessage = nextMessage == null || !nextMessage!.created.isSameDayAs(message.created);
    isNewAuthorToPreviousMessage = previousMessage == null || previousMessage!.personId != message.personId;
    isNewAuthorToNextMessage = nextMessage == null || nextMessage!.personId != message.personId;
    isTimeGapToPreviousMessage =
        previousMessage != null && message.created.difference(previousMessage!.created).inMinutes > 5;
    isTimeGapToNextMessage = nextMessage == null || nextMessage!.created.difference(message.created).inMinutes > 5;

    bool tempIsDetachedFromPreviousMessage = false;
    bool tempIsDetachedFromNextMessage = true;
    if (previousMessage != null && !isPreviousMessageAThread) {
      if (!isNewDayToPreviousMessage && !isNewAuthorToPreviousMessage && isTimeGapToPreviousMessage) {
        tempIsDetachedFromPreviousMessage = true;
      }
    }
    if (nextMessage != null && !hasThread) {
      if (!isNewDayToNextMessage && !isNewAuthorToNextMessage && !isTimeGapToNextMessage) {
        tempIsDetachedFromNextMessage = false;
      }
    }

    if (tempIsDetachedFromPreviousMessage) {
      if (tempIsDetachedFromNextMessage) {
        tempStackPosition = MessageStackPosition.single;
      } else {
        tempStackPosition = MessageStackPosition.top;
      }
    } else if (tempIsDetachedFromNextMessage) {
      tempStackPosition = MessageStackPosition.bottom;
    } else {
      tempStackPosition = MessageStackPosition.middle;
    }

    isDetachedFromPreviousMessage = tempIsDetachedFromPreviousMessage;
    isDetachedFromNextMessage = tempIsDetachedFromNextMessage;
    stackPosition = tempStackPosition;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = <Widget>[];

    if (!isNeverShowingTimeSeperator && isNewDayToPreviousMessage) {
      widgets.add(ChatTimeSeparator(dateTime: message.created));
    }
    if (!isNeverShowingAuthor &&
        (isNewDayToPreviousMessage || isNewAuthorToPreviousMessage || isPreviousMessageAThread)) {
      widgets.add(
        Skeletonizer(
          enabled: !ref.watch(personProvider(message.personId)).hasValue,
          child: PersonMessageAnnotation(
            person: ref.watch(personProvider(message.personId)).hasValue
                ? ref.watch(personProvider(message.personId)).value!
                : Person.placeholder(),
          ),
        ),
      );
    }

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ChatMessage(
          message: message,
          stackPosition: stackPosition,
          isShowingTime: true,
        ),
      ),
    );

    if (threadMessages != null && threadMessages!.isNotEmpty) {
      widgets.add(const SizedBox(height: 8));
      widgets.addAll(
        threadMessages!.reversed.map(
          (threadMessage) {
            final index = threadMessages!.indexOf(threadMessage);
            final isLastMessage = index == threadMessages!.length - 1;
            final previousMessage = ChatMessageFlow.getPreviousMessage(
              threadMessages!,
              index,
              isThreadMessageAllowed: true,
            );
            final nextMessage = ChatMessageFlow.getNextMessage(
              threadMessages!,
              index,
              isThreadMessageAllowed: true,
            );

            return Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: ChatMessageFlow(
                message: threadMessage,
                previousMessage: previousMessage,
                nextMessage: nextMessage,
                isNeverShowingTimeSeperator: true,
                isNeverShowingAuthor: isLastMessage && threadMessage.personId == message.personId,
              ),
            );
          },
        ),
      );
    }

    if (isDetachedFromNextMessage) widgets.add(const SizedBox(height: 8));

    if (widgets.length > 1) return Column(children: widgets);
    return widgets.first;
  }

  static Message? getPreviousMessage(List<Message> messages, int index, {bool isThreadMessageAllowed = false}) {
    while (true) {
      index++;
      if (index >= messages.length) return null;
      final message = messages[index];
      if (isThreadMessageAllowed || message.parentId == null) return message;
    }
  }

  static Message? getNextMessage(List<Message> messages, int index, {bool isThreadMessageAllowed = false}) {
    while (true) {
      index--;
      if (index < 0) return null;
      final message = messages[index];
      if (isThreadMessageAllowed || message.parentId == null) return message;
    }
  }
}
