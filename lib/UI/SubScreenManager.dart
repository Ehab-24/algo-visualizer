import 'package:algo_visualizer/Globals/decorations.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:algo_visualizer/Providers/ScreenProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../Globals/constants.dart';
import 'HomeScreen/NavBar.dart';
import 'PathfindingScreen/SideBarPathfinding.dart';
import 'SortingScreen/SideBarSorting.dart';

class SubScreenManager extends StatelessWidget {
  const SubScreenManager({super.key});

  @override
  Widget build(BuildContext context) {
    final w = screenWidth(context);
    final h = screenHeight(context);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: w,
            height: h,
          ),
          const MainBlock(),
          const NavBar(),
          const SideBar(),
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
    final w = screenWidth(context);
    final Screen screen = Provider.of<ScreenPr>(context).state;
    final Widget child;
    switch (screen) {
      case Screen.home:
        throw 'No sideBar found for Home Screen.';
      case Screen.explanation:
        return const SizedBox.shrink();
      case Screen.grid:
        child = const SideBarPathfinding();
        break;
      case Screen.array:
        child = const SideBarSorting();
        break;
    }
    return Positioned(
      left: w - sideBarWidth,
      child: Container(
        height: h,
        width: screen == Screen.home ? 0 : sideBarWidth,
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
      ),
    );
  }
}

class MainBlock extends StatelessWidget {
  const MainBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWatch = context.watch<ScreenPr>();
    return Positioned(
      left: navBarWidth,
      child: screenWatch.widget,
    );
  }
}
