import 'package:flutter/material.dart';
import 'package:webex_chat/src/core/models/team.dart';

class TeamTitleBar extends StatelessWidget {
  final Team _team;
  final Function _onBackPressed;

  const TeamTitleBar({required Team team, required Function onBackPressed, super.key})
      : _team = team,
        _onBackPressed = onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            foregroundColor: _team.colorScheme.onPrimary,
          ),
          onPressed: () {
            _onBackPressed();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        const SizedBox(width: 8),
        Text(
          _team.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
                color: _team.colorScheme.onPrimary,
              ),
        ),
      ],
    );
  }
}
