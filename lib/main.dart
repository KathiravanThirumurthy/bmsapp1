import 'package:bmsappversion1/pages/loginpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BmsApp());
}

class BmsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const curveHeight = 12.0;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber[900],
            shape: const MyShapeBorder(curveHeight),
          ),
          body: LoginPage(),
        ),
      ),
    );
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);
  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
