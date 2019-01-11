import 'package:flutter/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';
import 'package:tetris/gamer/gamer.dart';

const MATRIX_H = GAME_PAD_MATRIX_H;
const MATRIX_W = GAME_PAD_MATRIX_W;

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({Key key, @required double width})
      : assert(width != null && width != 0),
        size = Size(width, width * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    brikSize = Size((size.width - 6) / MATRIX_W, (size.height - 6) / MATRIX_H);
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: <Widget>[
            _PlayerPad(),
            _GameUninitialized(),
          ],
        ),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: gamer.data.map((list) {
        return Row(
          children: list.map((b) {
            return Brik(enable: b);
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconDragon(animate: true),
          SizedBox(height: 16),
          Text(
            "tetrix",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
