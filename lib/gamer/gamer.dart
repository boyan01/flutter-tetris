import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/gamer/block.dart';
import 'package:tetris/material/audios.dart';

///the height of game pad
const GAME_PAD_MATRIX_H = 20;

///the width of game pad
const GAME_PAD_MATRIX_W = 10;

///state of [GameControl]
enum GameStates {
  none,
  paused,
  running,
  reset,
  ended,
}

class Game extends StatefulWidget {
  final Widget child;

  const Game({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GameControl();
  }

  static GameControl of(BuildContext context) {
    final state = context.ancestorStateOfType(TypeMatcher<GameControl>());
    assert(state != null, "must wrap this context with [Game]");
    return state;
  }
}

///duration for show a line when reseting
const _REST_LINE_DURATION = const Duration(milliseconds: 50);

const _LEVEL_MAX = 6;

const _LEVEL_MIN = 1;

const _SPEED = [
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 650),
  const Duration(milliseconds: 500),
  const Duration(milliseconds: 370),
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 250),
  const Duration(milliseconds: 160),
];

class GameControl extends State<Game> {
  GameControl() {
    //inflate game pad data
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      _data.add(List.filled(GAME_PAD_MATRIX_W, 0));
    }
  }

  ///the gamer data
  final List<List<int>> _data = [];

  ///from 1-6
  int _level = 1;

  int _points = 0;

  int _cleared = 0;

  Block _current;

  Block _next = Block.getRandom();

  GameStates _states = GameStates.none;

  Block _getNext() {
    final next = _next;
    _next = Block.getRandom();
    return next;
  }

  void rotate() {
    if (_states == GameStates.running && _current != null) {
      final next = _current.rotate();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        sounds.rotate();
      }
    }
    setState(() {});
  }

  void right() {
    if (_states == GameStates.none && _level < _LEVEL_MAX) {
      _level++;
    } else if (_states == GameStates.running && _current != null) {
      final next = _current.right();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        sounds.move();
      }
    }
    setState(() {});
  }

  void left() {
    if (_states == GameStates.none && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.running && _current != null) {
      final next = _current.left();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        sounds.move();
      }
    }
    setState(() {});
  }

  void drop() {
    if (_states == GameStates.running && _current != null) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current.fall(step: i + 1);
        if (!fall.isValidInMatrix(_data)) {
          sounds.fall();
          _current = _current.fall(step: i);
          _mixCurrentIntoData();
          break;
        }
      }
      setState(() {});
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _scheduledRunning();
    }
  }

  void down({bool enableSounds = true}) {
    if (_states == GameStates.running && _current != null) {
      final next = _current.fall();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          sounds.move();
        }
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void _mixCurrentIntoData() {
    if (_current == null) {
      return;
    }
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GAME_PAD_MATRIX_W; j++) {
        _data[i][j] = _current.get(j, i) ?? _data[i][j];
      }
    }

    //消除行
    final clearLines = [];
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }
    if (clearLines.isNotEmpty) {
      clearLines.forEach((line) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(GAME_PAD_MATRIX_W, 0);
      });
      debugPrint("clear lines : $clearLines");
      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;
    }

    //检查游戏是否结束,即检查第一行是否有元素为1
    for (var item in _data[0]) {
      if (item != 0) {
        reset();
      }
    }

    if (_states == GameStates.reset) {
      _current = null;
    } else {
      _current = _getNext();
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    setState(() {});
  }

  void pauseOrResume() {
    if (_states == GameStates.running) {
      pause();
    } else {
      _scheduledRunning();
    }
  }

  void reset() {
    if (_states == GameStates.none) {
      //可以开始游戏
      _scheduledRunning();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    sounds.start();
    _states = GameStates.reset;
    () async {
      int line = GAME_PAD_MATRIX_H;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 1;
        }
        setState(() {});
        await Future.delayed(_REST_LINE_DURATION);
        return line != 0;
      });
      _current = null;
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 0;
        }
        setState(() {});
        line++;
        await Future.delayed(_REST_LINE_DURATION);
        return line != GAME_PAD_MATRIX_H;
      });
      setState(() {
        _states = GameStates.none;
      });
    }();
  }

  bool _runningScheduled = false;

  void _scheduledRunning() {
    if (_states == GameStates.running) {
      return;
    }
    _states = GameStates.running;
    _current = _current ?? _getNext();
    setState(() {});

    if (_runningScheduled) {
      return;
    }
    _runningScheduled = true;
    Future.doWhile(() async {
      if (!mounted) {
        return false;
      }
      await Future.delayed(_SPEED[_level]);
      down(enableSounds: false);
      return _states == GameStates.running;
    }).whenComplete(() {
      _runningScheduled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    for (var i = 0; i < GAME_PAD_MATRIX_H; i++) {
      mixed.add(List.filled(GAME_PAD_MATRIX_W, 0));
      for (var j = 0; j < GAME_PAD_MATRIX_W; j++) {
        mixed[i][j] = _current?.get(j, i) ?? _data[i][j];
      }
    }
    return GameState(
        mixed, _states, _level, sounds.muted, _points, _cleared, _next,
        child: widget.child);
  }

  void soundSwitch() {
    setState(() {
      sounds.muted = !sounds.muted;
    });
  }
}

class GameState extends InheritedWidget {
  GameState(this.data, this.states, this.level, this.muted, this.points,
      this.cleared, this.next,
      {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  final List<List<int>> data;

  final GameStates states;

  final int level;

  final bool muted;

  final int points;

  final int cleared;

  final Block next;

  static GameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameState) as GameState);
  }

  @override
  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
