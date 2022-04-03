import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gamer.dart';

///keyboard controller to play game
class KeyboardController extends StatefulWidget {
  final Widget child;

  KeyboardController({required this.child});

  @override
  _KeyboardControllerState createState() => _KeyboardControllerState();
}

class _KeyboardControllerState extends State<KeyboardController> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_onKey);
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      return;
    }

    final key = event.data.logicalKey;
    final game = Game.of(context);

    if (key == LogicalKeyboardKey.arrowUp) {
      game.rotate();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      game.down();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      game.left();
    } else if (key == LogicalKeyboardKey.arrowRight) {
      game.right();
    } else if (key == LogicalKeyboardKey.space) {
      game.drop();
    } else if (key == LogicalKeyboardKey.keyP) {
      game.pauseOrResume();
    } else if (key == LogicalKeyboardKey.keyS) {
      game.soundSwitch();
    } else if (key == LogicalKeyboardKey.keyR) {
      game.reset();
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
