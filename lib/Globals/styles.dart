import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';

class Styles {
  static TextStyle neon = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: 16,
    shadows: List<Shadow>.generate(
      3,
      (index) =>
          Shadow(color: secondary, blurRadius: index.toDouble() * 3),
    ).toList(),
  );
}
