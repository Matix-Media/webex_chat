import 'package:flutter/material.dart';

// Credits: https://gist.github.com/nank1ro/887fc73c1ddade4327294897aca5aebb
class VerticalSplitView extends StatefulWidget {
  const VerticalSplitView({
    required this.left,
    required this.right,
    this.ratio = 0.5,
    super.key,
  })  : assert(ratio >= 0, 'ratio must be >= 0'),
        assert(ratio <= 1, 'ratio must be <= 1');

  final Widget left;
  final Widget right;
  final double ratio;

  @override
  State<VerticalSplitView> createState() => _VerticalSplitViewState();
}

const _dividerWidth = 8.0;

class _VerticalSplitViewState extends State<VerticalSplitView> {
  //from 0-1
  late double _ratio;
  double? _maxWidth;

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;
  }

  double get _width1 => _ratio * _maxWidth!;

  double get _width2 => (1 - _ratio) * _maxWidth!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(_ratio <= 1, 'ratio must be <= 1');
        assert(_ratio >= 0, 'ratio must be >= 0');
        _maxWidth ??= constraints.maxWidth - _dividerWidth;
        if (_maxWidth != constraints.maxWidth) {
          _maxWidth = constraints.maxWidth - _dividerWidth;
        }

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: _width1,
                child: widget.left,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  excludeFromSemantics: true,
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: _dividerWidth,
                    height: constraints.maxHeight,
                    child: const RotationTransition(
                      turns: AlwaysStoppedAnimation(0.25),
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.drag_handle),
                      ),
                    ),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(
                      () {
                        _ratio += details.delta.dx / _maxWidth!;
                        if (_ratio > 1) {
                          _ratio = 1;
                        } else if (_ratio < 0.0) {
                          _ratio = 0.0;
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: _width2,
                child: widget.right,
              ),
            ],
          ),
        );
      },
    );
  }
}
