import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'player_panel.dart';
import 'status_panel.dart';

const Color screenBackground = Color(0xff9ead86);

/// screen H : W;
class Screen extends StatelessWidget {
  ///the with of screen
  final double width;

  const Screen({
    super.key,
    required this.width,
  });

  const Screen.fromHeight(double height, {Key? key})
      : this(width: ((height - 6) / 2 + 6) / 0.6, key: key);

  @override
  Widget build(BuildContext context) {
    //play panel need 60%
    final playerPanelWidth = width * 0.6;
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6,
        width: width,
        child: Container(
          color: screenBackground,
          child: GameMaterial(
            child: BrickSize(
              size: getBrikSizeForScreenWidth(playerPanelWidth),
              child: Row(
                children: <Widget>[
                  PlayerPanel(width: playerPanelWidth),
                  SizedBox(
                    width: width - playerPanelWidth,
                    child: const StatusPanel(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;

  ///true to shake screen vertically
  final bool shake;

  const Shake({
    super.key,
    required this.child,
    required this.shake,
  });

  @override
  State<Shake> createState() => _ShakeState();
}

///摇晃屏幕
class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150))
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

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}
