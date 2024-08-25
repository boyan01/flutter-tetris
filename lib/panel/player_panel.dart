import 'package:flutter/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';
import 'package:tetris/gamer/gamer.dart';

const playerPanelPadding = 6;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - playerPanelPadding) / gamePadMatrixW);
}

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({
    super.key,
    required double width,
  })  : assert(width != 0),
        size = Size(width, width * 2);

  @override
  Widget build(BuildContext context) {
    debugPrint("size : $size");
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: const EdgeInsets.all(2),
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
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1
                ? const Brick.normal()
                : b == 2
                    ? const Brick.highlight()
                    : const Brick.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GameState.of(context).states == GameStates.none) {
      return const Center(
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
    } else {
      return Container();
    }
  }
}
