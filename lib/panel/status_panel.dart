import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/gamer/block.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/generated/l10n.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';

class StatusPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(S.of(context).points,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).points),
          SizedBox(height: 10),
          Text(S.of(context).cleans,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).cleared),
          SizedBox(height: 10),
          Text(S.of(context).level,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).level),
          SizedBox(height: 10),
          Text(S.of(context).next,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          _NextBlock(),
          Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[GameState.of(context).next.type]!;
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1 ? const Brik.normal() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return new _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;

  bool _colonEnable = true;

  int _minute = 0;

  int _hour = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconSound(enable: GameState.of(context).muted),
        SizedBox(width: 4),
        IconPause(enable: GameState.of(context).states == GameStates.paused),
        Spacer(),
        Number(number: _hour, length: 2, padWithZero: true),
        IconColon(enable: _colonEnable),
        Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }
}
