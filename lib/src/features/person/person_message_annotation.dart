import 'package:flutter/material.dart';
import 'package:webex_chat/src/core/models/person.dart';

class PersonMessageAnnotation extends StatelessWidget {
  final Person _person;

  const PersonMessageAnnotation({required Person person, super.key}) : _person = person;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 24,
        height: 24,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            child: _person.avatar != null
                ? Image.network(
                    _person.avatar!,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                  )
                : const Icon(Icons.person),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(_person.displayName),
    ]);
  }
}
