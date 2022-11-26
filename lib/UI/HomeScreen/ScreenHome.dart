// ignore_for_file: non_constant_identifier_names

import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Globals/decorations.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:algo_visualizer/Providers/ScreenProvider.dart';
import 'package:algo_visualizer/UI/Helpers/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/GridProvider.dart';
import '../PathfindingScreen/SideBarPathfinding.dart';
import '../Searching/sideBarSearching.dart';
import '../SortingScreen/SideBarSorting.dart';
import 'NavBar.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => ScreenHomeState();
}

class ScreenHomeState extends State<ScreenHome> {
  late final GridPr gridReader;

  @override
  void initState() {
    gridReader = context.read<GridPr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Row(
        children: const [
          NavBar(),
          MainBlock(),
          SideBar(),
        ],
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final h = screenHeight(context);
    final Screen screen = Provider.of<ScreenPr>(context).state;
    final Widget? child;
    switch (screen) {
      case Screen.home:
        child = null;
        break;
      case Screen.grid:
        child = const SideBarPathfinding();
        break;
      case Screen.array:
        child = const SideBarSorting();
        break;
      case Screen.search:
        child = const SideBarSearching();
        break;
    }
    return Container(
      
      height: h,
      width: screen == Screen.home
      ? 0
      : sideBarWidth,
      decoration: Decorations.sideBar,
      child: AnimatedSwitcher(
        duration: d800,
        reverseDuration: d400,
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeOutQuad,
        transitionBuilder: ((child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                axisAlignment: -1.0,
                child: child,
              ),
        )),
        child: child,
      ),
    );
  }
}

class MainBlock extends StatelessWidget {
  const MainBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWatch = context.watch<ScreenPr>();
    return AnimatedSwitcher(
      duration: d0,
      // reverseDuration: d400,
      // switchInCurve: Curves.easeOutCirc,
      // switchOutCurve: Curves.easeInCirc,
      // transitionBuilder: ((child, animation) => FadeTransition(
      //       opacity: animation,
      //       child: ScaleTransition(
      //         scale: animation,
      //         child: child,
      //       ),
      //     )),
      child: screenWatch.widget,
    );
  }
}