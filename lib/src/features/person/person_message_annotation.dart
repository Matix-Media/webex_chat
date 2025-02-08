import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/models/person.dart';

class PersonMessageAnnotation extends StatelessWidget {
  final _logger = Logger('PersonMessageAnnotation');
  final Person _person;

  PersonMessageAnnotation({required Person person, super.key}) : _person = person;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(
        radius: 12,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        foregroundImage: _person.avatar != null ? NetworkImage(_person.avatar!) : null,
        onForegroundImageError: _person.avatar == null
            ? null
            : (error, stackTrace) {
                _logger.severe('Error loading person avatar: $error', error, stackTrace);
              },
        child: _person.avatar != null ? null : const Icon(Icons.person),
      ),
      const SizedBox(width: 8),
      Text(_person.displayName),
    ]);
  }
}
