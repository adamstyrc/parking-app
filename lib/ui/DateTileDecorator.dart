import 'package:flutter/material.dart';

class DateTileDecorator {
  static final LIGHTBLUE = new Color(0x881E88E5);

  static final _ORANGE_BORDER = Border.all(
    color: Colors.orange,
    width: 1.0,
  );
  static final _DARKBLUE_BORDER = Border.all(
    color: Colors.indigo,
    width: 1.0,
  );
  static final _WHITE_BORDER = Border.all(
    color: Colors.white,
    width: 1.0,
  );

  static final GREY_CIRCLE =
      BoxDecoration(color: Colors.grey, shape: BoxShape.circle);
  static final GREY_CIRCLE_BORDERED = BoxDecoration(
      color: Colors.grey, shape: BoxShape.circle, border: _ORANGE_BORDER);
  static final BLUE_CIRCLE =
      BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
  static final BLUE_CIRCLE_BORDERED = BoxDecoration(
      color: Colors.blue, shape: BoxShape.circle, border: _ORANGE_BORDER);
  static final BLUE_CIRCLE_BLUE_BORDERED = BoxDecoration(
      color: Colors.blue, shape: BoxShape.circle, border: _DARKBLUE_BORDER);
  static final LIGHTBLUE_CIRCLE =
//  BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle);
  BoxDecoration(color: LIGHTBLUE, shape: BoxShape.circle);
  static final ORANGE_BORDER =
  BoxDecoration(shape: BoxShape.circle, border: _ORANGE_BORDER);
  static final WHITE_BORDER =
  BoxDecoration(shape: BoxShape.circle, border: _WHITE_BORDER);
  static final WHITE_CIRCLE =
  BoxDecoration(color: Colors.white, shape: BoxShape.circle);
}
