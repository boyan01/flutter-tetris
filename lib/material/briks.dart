import 'package:flutter/material.dart';

const colorNormal = Colors.black87;
const colorNull = Colors.black12;
const colorHighlight = Color(0xFF560000);

class BrickSize extends InheritedWidget {
  const BrickSize({
    super.key,
    required this.size,
    required super.child,
  });

  final Size size;

  static BrickSize of(BuildContext context) {
    final brickSize = context.dependOnInheritedWidgetOfExactType<BrickSize>();
    assert(brickSize != null, "....");
    return brickSize!;
  }

  @override
  bool updateShouldNotify(BrickSize oldWidget) {
    return oldWidget.size != size;
  }
}

///the basic brick for game panel
class Brick extends StatelessWidget {
  final Color color;

  const Brick._({super.key, required this.color});

  const Brick.normal({Key? key}) : this._(color: colorNormal, key: key);

  const Brick.empty({Key? key}) : this._(color: colorNull, key: key);

  const Brick.highlight({Key? key}) : this._(color: colorHighlight, key: key);

  @override
  Widget build(BuildContext context) {
    final width = BrickSize.of(context).size.width;
    return SizedBox.fromSize(
      size: BrickSize.of(context).size,
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
