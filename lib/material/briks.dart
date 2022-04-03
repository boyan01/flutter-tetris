import 'package:flutter/material.dart';

const _COLOR_NORMAL = Colors.black87;

const _COLOR_NULL = Colors.black12;

const _COLOR_HIGHLIGHT = Color(0xFF560000);

class BrikSize extends InheritedWidget {
  const BrikSize({
    Key? key,
    required this.size,
    required Widget child,
  }) : super(key: key, child: child);

  final Size size;

  static BrikSize of(BuildContext context) {
    final brikSize = context.dependOnInheritedWidgetOfExactType<BrikSize>();
    assert(brikSize != null, "....");
    return brikSize!;
  }

  @override
  bool updateShouldNotify(BrikSize old) {
    return old.size != size;
  }
}

///the basic brik for game panel
class Brik extends StatelessWidget {
  final Color color;

  const Brik._({Key? key, required this.color}) : super(key: key);

  const Brik.normal() : this._(color: _COLOR_NORMAL);

  const Brik.empty() : this._(color: _COLOR_NULL);

  const Brik.highlight() : this._(color: _COLOR_HIGHLIGHT);

  @override
  Widget build(BuildContext context) {
    final width = BrikSize.of(context).size.width;
    return SizedBox.fromSize(
      size: BrikSize.of(context).size,
      child: Container(
        margin: EdgeInsets.all(0.05 * width),
        padding: EdgeInsets.all(0.1 * width),
        decoration: BoxDecoration(
            border: Border.all(width: 0.10 * width, color: color)),
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
