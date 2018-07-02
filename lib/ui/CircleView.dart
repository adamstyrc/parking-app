import 'package:flutter/material.dart';

class CircleView extends StatelessWidget {

  Color color;
  double radius;

  CircleView({
    Key key,
    this.color,
    this.radius
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(color: this.color, shape: BoxShape.circle),
      height: radius * 2,
      width: radius * 2,
    );
  }
}