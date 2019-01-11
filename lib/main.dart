import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/material/images.dart';
import 'package:tetris/panel/screen.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    _doLoadMaterial();
  }

  void _doLoadMaterial() async {
    final bytes = await rootBundle.load("assets/material.png");
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      material = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width * 0.8;

    Widget screen;
    if (material != null) {
      screen = Screen(width: screenW);
    }
    return Container(
      color: Color(0xffefcc19),
      child: Center(
        child: screen,
      ),
    );
  }
}
