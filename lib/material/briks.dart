import 'package:flutter/material.dart';

///the size of a single brik
Size brikSize = Size(16, 16);

abstract class CombinedBriks extends StatelessWidget {
  final List<List<bool>> data;

  const CombinedBriks({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = data.map((row) {
      return Row(
        children: row.map((e) {
          return e ? Brik() : BrikNull();
        }).toList(),
      );
    }).toList();
    return Column(
      children: children,
    );
  }

  CombinedBriks rotate();
}

class BrikNull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: brikSize,
    );
  }
}

///the basic brik for game panel
class Brik extends StatelessWidget {
  final bool enable;

  const Brik({Key key, this.enable = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = enable ? Colors.black87 : Colors.black12;

    return SizedBox.fromSize(
      size: brikSize,
      child: Container(
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(width: 2, color: color)),
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
