import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';

class Styles {
  static TextStyle neon([double size = 16]) => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: size,
    shadows: List<Shadow>.generate(
      3,
      (i) =>
          Shadow(color: secondary, blurRadius: i * 3),
    ).toList(),
  );
}
