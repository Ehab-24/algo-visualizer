import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';

import '../../Globals/functions.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context) - sideBarWidth - navBarWidth,
      height: screenHeight(context),
      child: const Center(child: Text('Home')),
    );
  }
}
