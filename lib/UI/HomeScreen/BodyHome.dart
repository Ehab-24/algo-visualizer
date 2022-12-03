import 'dart:ui';

import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ScreenProvider.dart';
import '../Helpers/Buttons.dart';
import '../Helpers/CurvedPainter.dart';

ValueNotifier<bool> isScreenHovering = ValueNotifier<bool>(false);

class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  late final ScreenPr screenReader;

  @override
  void initState() {
    screenReader = context.read<ScreenPr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = screenHeight(context);
    final w = screenWidth(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          space120v,
          const Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'VarelaRound',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: h * 0.1,
          ),
          SizedBox(
            width: w * 0.6,
            child: const Text(
              'Learn famous sorting and pathfinding algorithms with interactive animations and well documented explanations.',
              style: TextStyle(
                fontFamily: 'Farsan',
                color: Colors.white,
                fontSize: 18,
                wordSpacing: 1.5,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: h * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavigationCard(
                icon: Icons.grid_view,
                label: 'Pathfinding',
                isScreenHovering: isScreenHovering,
                onPressed: () => _setScreen('grid'),
              ),
              space40h,
              NavigationCard(
                icon: Icons.sort,
                label: 'Sorting',
                isScreenHovering: isScreenHovering,
                onPressed: () => _setScreen('array'),
              ),
            ],
          ),
          // SizedBox(height: h * 0.25),

          // CustomPaint(
          //   size: Size(w, 300),
          //   painter: CurvedPainter(primary),
          // ),
          // Container(
          //   height: 300,
          //   color: primary,
          // ),

          // // CustomPaint(
          // //   size: Size(w, 300),
          // //   painter: CurvedPainter(Colors.amber),
          // // ),
          // Container(
          //   height: 600,
          //   color: Colors.amber,
          // )
        ],
      ),
    );
  }

  void _setScreen(String screen) {
    isScreenHovering.value = false;
    screenReader.setScreen(screen);
  }
}
