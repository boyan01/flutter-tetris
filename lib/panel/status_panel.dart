import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/material/images.dart';

class StatusPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _NumberLine(title: "Points", number: 0),
          SizedBox(height: 10),
          _NumberLine(title: "Cleans", number: 0),
          SizedBox(height: 10),
          _NumberLine(title: "Level", number: 0),
          Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

///a status line which containes a number
class _NumberLine extends StatelessWidget {
  final String title;
  final int number;

  const _NumberLine({Key key, @required this.title, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: number),
        ],
      ),
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
  Timer _timer;

  bool _colonEnable = true;

  int _minute;

  int _hour;

  @override
  void initState() {
    super.initState();
    debugPrint("init state");
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
        IconSound(),
        SizedBox(width: 4),
        IconPause(),
        Spacer(),
        Number(number: _hour, length: 2, padWithZero: true),
        IconColon(enable: _colonEnable),
        Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }
}
