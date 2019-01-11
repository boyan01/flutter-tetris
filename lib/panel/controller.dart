import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tetris/gamer/gamer.dart';

class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Center(
              child: _Button(
                size: Size(90, 90),
                onTap: () {
                  gamer.drop();
                },
              ),
            ),
          )),
          Expanded(child: _DirectionController()),
        ],
      ),
    );
  }
}

const Size _DIRECTION_BUTTON_SIZE = const Size(60, 60);

const double _DIRECTION_SPACE = 10;

class _DirectionController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      gamer.rotate();
                    }),
                SizedBox(width: _DIRECTION_SPACE),
                _Button(
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      gamer.right();
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
                      gamer.left();
                    }),
                SizedBox(width: _DIRECTION_SPACE),
                _Button(
                  size: _DIRECTION_BUTTON_SIZE,
                  onTap: () {
                    gamer.down();
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

enum Direction { up, down, left, right }

class _Button extends StatelessWidget {
  final Size size;

  final VoidCallback onTap;

  const _Button({Key key, @required this.size, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: CircleBorder(),
      child: InkResponse(onTap: onTap, child: SizedBox.fromSize(size: size)),
    );
  }
}
