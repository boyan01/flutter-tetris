import 'package:flutter/material.dart';

///the height of game pad
const GAME_PAD_MATRIX_H = 20;

///the width of game pad
const GAME_PAD_MATRIX_W = 10;

///state of [Gamer]
enum GamerState { none, paused, running }

Gamer gamer = Gamer._();

class Gamer {
  Gamer._() {
    //inflate game pad data
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      _data.add(List.filled(GAME_PAD_MATRIX_W, false));
    }
  }

  ///the gamer data
  final List<List<bool>> _data = [];
  List<List<bool>> get data => _data;

  void rotate() {
    debugPrint("rotate");
  }

  void right() {
    debugPrint("right");
  }

  void left() {
    debugPrint("left");
  }

  void drop() {
    debugPrint("drop");
  }

  void down() {
    debugPrint("down");
  }
}
