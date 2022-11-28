// ignore_for_file: non_constant_identifier_names

import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';
import 'BodyHome.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: background,
      body: BodyHome(),
    );
  }
}