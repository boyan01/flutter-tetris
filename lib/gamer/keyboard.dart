import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gamer.dart';

///keyboard controller to play game
class KeyboardController extends StatefulWidget {
  final Widget child;

  const KeyboardController({super.key, required this.child});

  @override
  State<KeyboardController> createState() => _KeyboardControllerState();
}

class _KeyboardControllerState extends State<KeyboardController> {
  @override
  void initState() {
    super.initState();
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey;
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
    } else {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Game.of(context);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyP): game.pauseOrResume,
        const SingleActivator(LogicalKeyboardKey.keyS): game.soundSwitch,
        const SingleActivator(LogicalKeyboardKey.keyR): game.reset,
        const SingleActivator(LogicalKeyboardKey.arrowUp): game.rotate,
        const SingleActivator(LogicalKeyboardKey.arrowDown): game.down,
        const SingleActivator(LogicalKeyboardKey.arrowLeft): game.left,
        const SingleActivator(LogicalKeyboardKey.arrowRight): game.right,
        const SingleActivator(LogicalKeyboardKey.space): game.drop,
      },
      child: Focus(autofocus: true, child: widget.child),
    );
  }
}
