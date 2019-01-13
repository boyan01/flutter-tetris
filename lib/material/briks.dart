import 'package:flutter/material.dart';

///the size of a single brik
Size brikSize = Size(16, 16);

const _COLOR_NORMAL = Colors.black87;

const _COLOR_NULL = Colors.black12;

const _COLOR_HIGHLIGHT = Color(0xFF3E2723);

///the basic brik for game panel
class Brik extends StatelessWidget {
  final Color color;

  const Brik._({Key key, this.color}) : super(key: key);

  const Brik.normal() : this._(color: _COLOR_NORMAL);

  const Brik.empty() : this._(color: _COLOR_NULL);

  const Brik.highlight() : this._(color: _COLOR_HIGHLIGHT);

  @override
  Widget build(BuildContext context) {
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
