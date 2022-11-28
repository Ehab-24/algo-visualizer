
import 'dart:ui';

import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:algo_visualizer/UI/Helpers/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ScreenProvider.dart';

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
    final w = screenWidth(context);
    return SizedBox(
      width: w,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            space20v,
            SizedBox(
              width: w * 0.6,
              child: const Text(
                'Learn famous sorting and pathfinding algorithms with interactive animations and well documented explanations.',
                style: TextStyle(fontSize: 14, letterSpacing: 1.0),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationCard(
                  icon: Icons.grid_view,
                  label: 'Pathfinding',
                  onPressed: () => screenReader.setScreen('grid'),
                ),
                space30h,
                NavigationCard(
                  icon: Icons.sort,
                  label: 'Sorting',
                  onPressed: () => screenReader.setScreen('array'),
                ),
                // space30h,
                // NavigationCard(
                //   icon: Icons.library_books_outlined,
                //   label: 'Elaborations',
                //   onPressed: () => screenReader.setScreen('explanation'),
                // ),
              ],
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
