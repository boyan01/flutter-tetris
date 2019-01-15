import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/generated/i18n.dart';

class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

const Size _DIRECTION_BUTTON_SIZE = const Size(60, 60);

const Size _SYSTEM_BUTTON_SIZE = const Size(28, 28);

const double _DIRECTION_SPACE = 10;

class DirectionController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: _DIRECTION_BUTTON_SIZE * 2 * 1.41,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _DIRECTION_SPACE),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Button(
                    enableLongPress: false,
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      Game.of(context).rotate();
                    }),
                SizedBox(width: _DIRECTION_SPACE),
                _Button(
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      Game.of(context).right();
                    }),
              ],
            ),
            SizedBox(height: _DIRECTION_SPACE),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Button(
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      Game.of(context).left();
                    }),
                SizedBox(width: _DIRECTION_SPACE),
                _Button(
                  size: _DIRECTION_BUTTON_SIZE,
                  onTap: () {
                    Game.of(context).down();
                  },
                ),
              ],
            ),
            SizedBox(height: _DIRECTION_SPACE),
          ],
        ),
      ),
    );
  }
}

class SystemButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _SystemButton(
          color: const Color(0xFF2dc421),
          label: S.of(context).sounds,
          onTap: () {
            Game.of(context).soundSwitch();
          },
        ),
        _SystemButton(
          color: const Color(0xFF2dc421),
          label: S.of(context).pause_resume,
          onTap: () {
            Game.of(context).pauseOrResume();
          },
        ),
        _SystemButton(
            color: Colors.red,
            label: S.of(context).reset,
            onTap: () {
              Game.of(context).reset();
            })
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Button(
        enableLongPress: false,
        size: Size(90, 90),
        onTap: () {
          Game.of(context).drop();
        });
  }
}

class LeftController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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

class _SystemButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _SystemButton({
    Key key,
    this.color = Colors.blue,
    @required this.label,
    @required this.onTap,
  })  : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipOval(
            child: SizedBox.fromSize(
                size: _SYSTEM_BUTTON_SIZE,
                child: RaisedButton(
                  onPressed: onTap,
                  child: Container(),
                  color: color,
                ))),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
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

  const _Button(
      {Key key,
      @required this.size,
      @required this.onTap,
      this.color = Colors.blue,
      this.enableLongPress = true})
      : super(key: key);

  @override
  _ButtonState createState() {
    return new _ButtonState();
  }
}

class _ButtonState extends State<_Button> {
  Timer _timer;

  bool _tapEnded = false;

  Color _color;

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
      shape: CircleBorder(),
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
        child: SizedBox.fromSize(size: widget.size),
      ),
    );
  }
}
