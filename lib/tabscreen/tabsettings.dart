import 'package:flutter/material.dart';

class TabSettings extends StatelessWidget {
  final Color color;
  TabSettings(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
