import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gamer.dart';

///keyboard controller to play game
class KeyboardController extends StatefulWidget {
  final Widget child;

  KeyboardController({this.child});

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

    final key = event.data.physicalKey;
    final game = Game.of(context);

    if (key == PhysicalKeyboardKey.arrowUp) {
      game.rotate();
    } else if (key == PhysicalKeyboardKey.arrowDown) {
      game.down();
    } else if (key == PhysicalKeyboardKey.arrowLeft) {
      game.left();
    } else if (key == PhysicalKeyboardKey.arrowRight) {
      game.right();
    } else if (key == PhysicalKeyboardKey.space) {
      game.drop();
    } else if (key == PhysicalKeyboardKey.keyP) {
      game.pauseOrResume();
    } else if (key == PhysicalKeyboardKey.keyS) {
      game.soundSwitch();
    } else if (key == PhysicalKeyboardKey.keyR) {
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
