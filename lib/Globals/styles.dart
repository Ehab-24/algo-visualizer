import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';

class Styles {
  static TextStyle neon([double size = 14]) => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: size,
    letterSpacing: 0.8,
    shadows: List<Shadow>.generate(
      3,
      (i) =>
          Shadow(color: secondary, blurRadius: i * 3),
    ).toList(),
  );
  static const TextStyle b4 = TextStyle(
    fontSize: 14,
    letterSpacing: 1.0,
  );
  static const TextStyle b3 = TextStyle(
    fontSize: 12,
    letterSpacing: 1.0,
    fontFamily: 'VarelaRound'
  );
}
