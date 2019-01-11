import 'package:flutter/material.dart';
import 'player_panel.dart';
import 'status_panel.dart';

const Color _background = Color(0xff9ead86);

class Screen extends StatelessWidget {
  ///the with of scrren
  final double width;

  const Screen({Key key, @required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //play panel need 70%
    final playerPanelWidth = width * 0.6;
    return SizedBox(
      height: playerPanelWidth * 2,
      width: width,
      child: Container(
        color: _background,
        child: Row(
          children: <Widget>[
            PlayerPanel(width: playerPanelWidth),
            SizedBox(
              width: width - playerPanelWidth,
              child: StatusPanel(),
            )
          ],
        ),
      ),
    );
  }
}
