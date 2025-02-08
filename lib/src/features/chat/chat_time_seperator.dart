import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatTimeSeparator extends StatelessWidget {
  static final _dateFormat = DateFormat('E. d. MMM');
  final DateTime _dateTime;

  const ChatTimeSeparator({required DateTime dateTime, super.key}) : _dateTime = dateTime;

  String get _formattedDate {
    final now = DateTime.now();
    if (_dateTime.year == now.year && _dateTime.month == now.month && _dateTime.day == now.day) {
      return "Today";
    }
    return _dateFormat.format(_dateTime);
    // if the date of the message is today, show the time
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Theme.of(context).colorScheme.surfaceContainerLow)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            _dateFormat.format(_dateTime),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Theme.of(context).colorScheme.surfaceContainerLow)),
      ],
    );
  }
}
