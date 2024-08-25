import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/generated/l10n.dart';

class GameController extends StatelessWidget {
  const GameController({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(child: LeftController()),
          Expanded(child: DirectionController()),
        ],
      ),
    );
  }
}

const Size directionButtonSize = Size(48, 48);

const Size systemButtonSize = Size(28, 28);

const double directionSpace = 16;

const double _iconSize = 16;

class DirectionController extends StatelessWidget {
  const DirectionController({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox.fromSize(size: directionButtonSize * 2.8),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_right,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_left,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: directionSpace),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _Button(
                      enableLongPress: false,
                      size: directionButtonSize,
                      onTap: () {
                        Game.of(context).rotate();
                      }),
                  const SizedBox(width: directionSpace),
                  _Button(
                      size: directionButtonSize,
                      onTap: () {
                        Game.of(context).right();
                      }),
                ],
              ),
              const SizedBox(height: directionSpace),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _Button(
                      size: directionButtonSize,
                      onTap: () {
                        Game.of(context).left();
                      }),
                  const SizedBox(width: directionSpace),
                  _Button(
                    size: directionButtonSize,
                    onTap: () {
                      Game.of(context).down();
                    },
                  ),
                ],
              ),
              const SizedBox(height: directionSpace),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemButtonGroup extends StatelessWidget {
  static const _systemButtonColor = Color(0xFF2dc421);

  const SystemButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _Description(
          text: S.of(context).sounds,
          child: _Button(
              size: systemButtonSize,
              color: _systemButtonColor,
              enableLongPress: false,
              onTap: () {
                Game.of(context).soundSwitch();
              }),
        ),
        _Description(
          text: S.of(context).pause_resume,
          child: _Button(
              size: systemButtonSize,
              color: _systemButtonColor,
              enableLongPress: false,
              onTap: () {
                Game.of(context).pauseOrResume();
              }),
        ),
        _Description(
          text: S.of(context).reset,
          child: _Button(
              size: systemButtonSize,
              enableLongPress: false,
              color: Colors.red,
              onTap: () {
                Game.of(context).reset();
              }),
        )
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  const DropButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Description(
      text: 'drop',
      child: _Button(
          enableLongPress: false,
          size: const Size(90, 90),
          onTap: () {
            Game.of(context).drop();
          }),
    );
  }
}

class LeftController extends StatelessWidget {
  const LeftController({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SystemButtonGroup(),
        Expanded(
          child: Center(
            child: DropButton(),
          ),
        )
      ],
    );
  }
}

class _Button extends StatefulWidget {
  final Size size;

  final VoidCallback onTap;

  ///the color of button
  final Color color;

  final bool enableLongPress;

  const _Button({
    required this.size,
    required this.onTap,
    this.color = Colors.blue,
    this.enableLongPress = true,
  });

  @override
  _ButtonState createState() {
    return _ButtonState();
  }
}

///show a hint text for child widget
class _Description extends StatelessWidget {
  final String text;

  final Widget child;

  final AxisDirection direction;

  const _Description({
    required this.text,
    this.direction = AxisDirection.down,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (direction) {
      case AxisDirection.right:
        widget = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[child, const SizedBox(width: 8), Text(text)]);
        break;
      case AxisDirection.left:
        widget = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Text(text), const SizedBox(width: 8), child],
        );
        break;
      case AxisDirection.up:
        widget = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Text(text), const SizedBox(height: 8), child],
        );
        break;
      case AxisDirection.down:
        widget = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[child, const SizedBox(height: 8), Text(text)],
        );
        break;
    }
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12, color: Colors.black),
      child: widget,
    );
  }
}

class _ButtonState extends State<_Button> {
  Timer? _timer;

  bool _tapEnded = false;

  late Color _color;

  @override
  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = widget.color;
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      elevation: 2,
      shape: const CircleBorder(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) async {
          setState(() {
            _color = widget.color.withOpacity(0.5);
          });
          if (_timer != null) {
            return;
          }
          _tapEnded = false;
          widget.onTap();
          if (!widget.enableLongPress) {
            return;
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (_tapEnded) {
            return;
          }
          _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
            if (!_tapEnded) {
              widget.onTap();
            } else {
              t.cancel();
              _timer = null;
            }
          });
        },
        onTapCancel: () {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        onTapUp: (_) {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        child: SizedBox.fromSize(
          size: widget.size,
        ),
      ),
    );
  }
}
