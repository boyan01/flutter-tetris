import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/material/images.dart';
import 'player_panel.dart';
import 'status_panel.dart';

const Color _background = Color(0xff9ead86);

class Screen extends StatefulWidget {
  ///the with of scrren
  final double width;

  const Screen({Key key, @required this.width}) : super(key: key);

  @override
  ScreenState createState() {
    return new ScreenState();
  }
}

class ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
    _doLoadMaterial();
  }

  void _doLoadMaterial() async {
    if (material != null) {
      return;
    }
    final bytes = await rootBundle.load("assets/material.png");
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      material = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    //play panel need 70%
    final playerPanelWidth = widget.width * 0.6;
    return SizedBox(
      height: playerPanelWidth * 2,
      width: widget.width,
      child: Container(
        color: _background,
        child: material == null
            ? null
            : Row(
                children: <Widget>[
                  PlayerPanel(width: playerPanelWidth),
                  SizedBox(
                    width: widget.width - playerPanelWidth,
                    child: StatusPanel(),
                  )
                ],
              ),
      ),
    );
  }
}
