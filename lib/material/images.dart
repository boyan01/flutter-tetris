import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'material.dart';

const _DIGITAL_ROW_SIZE = Size(14, 24);

class Number extends StatelessWidget {
  final int length;

  ///the number to show
  ///could be null
  final int number;

  final bool padWithZero;

  Number({
    Key? key,
    this.length = 5,
    required this.number,
    this.padWithZero = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String digitalStr = number.toString();
    if (digitalStr.length > length) {
      digitalStr = digitalStr.substring(digitalStr.length - length);
    }
    digitalStr = digitalStr.padLeft(length, padWithZero ? "0" : " ");
    List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      children.add(Digital(int.tryParse(digitalStr[i]) ?? 0));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class IconDragon extends StatefulWidget {
  final bool animate;

  const IconDragon({Key? key, this.animate = false}) : super(key: key);

  @override
  _IconDragonState createState() {
    return new _IconDragonState();
  }
}

class _IconDragonState extends State<IconDragon> {
  Timer? _timer;

  @override
  void didUpdateWidget(IconDragon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimation();
  }

  ///current frame of animation
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _timer?.cancel();
    _timer = null;
    if (!widget.animate) {
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (_frame > 30) {
        _frame = 0;
      }
      setState(() {
        _frame++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Material(
      size: const Size(80, 86),
      srcSize: const Size(80, 86),
      srcOffset: _getOffset(_frame),
    );
  }

  Offset _getOffset(int frame) {
    int index = 0;
    if (frame < 10) {
      index = frame % 2 == 0 ? 0 : 1;
    } else {
      index = frame % 2 == 0 ? 2 : 3;
    }
    double dx = index * 100.0;
    return Offset(dx, 100);
  }
}

class IconPause extends StatelessWidget {
  final bool enable;
  final Size size;

  const IconPause(
      {Key? key, this.enable = true, this.size = const Size(18, 16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Material(
      size: size,
      srcSize: const Size(20, 18),
      srcOffset: enable ? const Offset(75, 75) : const Offset(100, 75),
    );
  }
}

class IconSound extends StatelessWidget {
  final bool enable;
  final Size size;

  const IconSound(
      {Key? key, this.enable = true, this.size = const Size(18, 16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Material(
      size: size,
      srcSize: const Size(25, 21),
      srcOffset: enable ? const Offset(150, 75) : const Offset(175, 75),
    );
  }
}

class IconColon extends StatelessWidget {
  final bool enable;

  final Size size;

  const IconColon(
      {Key? key, this.enable = true, this.size = const Size(10, 17)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Material(
      size: size,
      srcOffset: enable ? const Offset(229, 25) : const Offset(243, 25),
      srcSize: _DIGITAL_ROW_SIZE,
    );
  }
}

/// a single digital
class Digital extends StatelessWidget {
  ///number 0 - 9
  ///or null indicate it is invalid
  final int digital;

  final Size size;

  Digital(this.digital, {Key? key, this.size = const Size(10, 17)})
      : assert((digital <= 9 && digital >= 0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Material(
      size: size,
      srcOffset: _getDigitalOffset(),
      srcSize: _DIGITAL_ROW_SIZE,
    );
  }

  Offset _getDigitalOffset() {
    int offset = digital;
    final dx = 75.0 + 14 * offset;
    return Offset(dx, 25);
  }
}

class _Material extends StatelessWidget {
  //the size off widget
  final Size size;

  final Size srcSize;

  final Offset srcOffset;

  const _Material({
    Key? key,
    required this.size,
    required this.srcSize,
    required this.srcOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _MaterialPainter(
        srcOffset,
        srcSize,
        GameMaterial.getMaterial(context),
      ),
      child: SizedBox.fromSize(
        size: size,
      ),
    );
  }
}

class _MaterialPainter extends CustomPainter {
  ///offset to adjust the drawing
  final Offset offset;

  ///the size we pick from [_material]
  final Size size;

  final ui.Image material;

  _MaterialPainter(this.offset, this.size, this.material);

  Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final src =
        Rect.fromLTWH(offset.dx, offset.dy, this.size.width, this.size.height);
    canvas.scale(size.width / this.size.width, size.height / this.size.height);
    canvas.drawImageRect(material, src,
        Rect.fromLTWH(0, 0, this.size.width, this.size.height), _paint);
  }

  @override
  bool shouldRepaint(_MaterialPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.size != size;
  }
}
