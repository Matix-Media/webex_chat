import 'package:flutter/material.dart';
import 'package:webex_chat/src/core/models/room.dart';
import 'package:webex_chat/src/core/models/team.dart';

class ChatTitleBar extends StatelessWidget {
  final Room _room;

  const ChatTitleBar({required Room room, super.key}) : _room = room;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.forum_outlined),
        const SizedBox(width: 8),
        Text(
          _room.title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
