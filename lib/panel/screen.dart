import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'player_panel.dart';
import 'status_panel.dart';

const Color SCREEN_BACKGROUND = Color(0xff9ead86);

/// screen H : W;
class Screen extends StatefulWidget {
  ///the with of screen
  final double width;

  const Screen({Key key, @required this.width}) : super(key: key);

  Screen.fromHeight(double height) : this(width: ((height - 6) / 2 + 6) / 0.6);

  @override
  ScreenState createState() {
    return new ScreenState();
  }
}

class ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
    _doLoadMaterial();
  }

  void _doLoadMaterial() async {
    if (material != null) {
      return;
    }
    final bytes = await rootBundle.load("assets/material.png");
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      material = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    //play panel need 60%
    final playerPanelWidth = widget.width * 0.6;
    Widget screen;
    if (material != null) {
      screen = BrikSize(
        size: getBrikSizeForScreenWidth(playerPanelWidth),
        child: Row(
          children: <Widget>[
            PlayerPanel(width: playerPanelWidth),
            SizedBox(
              width: widget.width - playerPanelWidth,
              child: StatusPanel(),
            )
          ],
        ),
      );
    }

    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6,
        width: widget.width,
        child: Container(
          color: SCREEN_BACKGROUND,
          child: screen,
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;

  final bool shake;

  const Shake({Key key, @required this.child, @required this.shake})
      : super(key: key);

  @override
  _ShakeState createState() => _ShakeState();
}

///摇晃屏幕
class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(getTranslation()),
      child: widget.child,
    );
  }
}
