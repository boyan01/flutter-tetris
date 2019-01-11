import 'package:flutter/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';

const MATRIX_H = 20;
const MATRIX_W = 10;

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
            _PlayerBackground(),
            _GameUninitialized(),
          ],
        ),
      ),
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

class _PlayerBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (int i = 0; i < MATRIX_H; i++) {
      List<Widget> children = [];
      for (int j = 0; j < MATRIX_W; j++) {
        children.add(Brik(enable: false));
      }
      Row row = Row(children: children);
      rows.add(row);
    }
    return Column(
      children: rows,
    );
  }
}
