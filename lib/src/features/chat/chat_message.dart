import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webex_chat/src/core/models/message.dart';

class ChatMessage extends StatelessWidget {
  static final _dateFormat = DateFormat('HH:mm');

  final Message _message;
  final MessageStackPosition _stackPosition;
  final MessageDirection _direction;
  final bool _isShowingTime;

  const ChatMessage({
    required Message message,
    MessageStackPosition stackPosition = MessageStackPosition.single,
    MessageDirection direction = MessageDirection.incoming,
    bool isShowingTime = false,
    super.key,
  })  : _message = message,
        _stackPosition = stackPosition,
        _direction = direction,
        _isShowingTime = isShowingTime;

  BorderRadius get _borderRadius {
    double topLeft = 12;
    double topRight = 12;
    double bottomLeft = 12;
    double bottomRight = 12;

    if (_direction == MessageDirection.incoming) {
      if (_stackPosition == MessageStackPosition.top) {
        bottomLeft = 4;
      } else if (_stackPosition == MessageStackPosition.middle) {
        topLeft = 4;
        bottomLeft = 4;
      } else if (_stackPosition == MessageStackPosition.bottom) {
        topLeft = 4;
      }
    } else if (_direction == MessageDirection.outgoing) {
      if (_stackPosition == MessageStackPosition.top) {
        topRight = 4;
      } else if (_stackPosition == MessageStackPosition.middle) {
        topRight = 4;
        bottomRight = 4;
      } else if (_stackPosition == MessageStackPosition.bottom) {
        bottomRight = 4;
      }
    }

    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _direction == MessageDirection.incoming ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                double messageWidth = maxWidth * 0.8;

                return Card.filled(
                  margin: EdgeInsets.only(
                      top: _stackPosition == MessageStackPosition.top ? 4 : 2,
                      bottom: _stackPosition == MessageStackPosition.bottom ? 4 : 2),
                  shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: messageWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Text(
                        _message.text ?? "/// No text ///",
                        softWrap: true,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        if (_isShowingTime)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              _dateFormat.format(_message.created),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(150)),
            ),
          ),
      ],
    );
  }
}

enum MessageDirection {
  incoming,
  outgoing,
}

enum MessageStackPosition {
  top,
  middle,
  bottom,
  single,
}
