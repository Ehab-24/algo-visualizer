import 'package:algo_visualizer/Globals/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Globals/constants.dart';
import '../../Globals/decorations.dart';
import '../../Providers/ScreenProvider.dart';
import '../Helpers/Buttons.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = Provider.of<ScreenPr>(context).state;
    final h = screenHeight(context);
    
    double hoverContainerPosition;
    switch (screen) {
      case Screen.home:
        hoverContainerPosition = h/2 - 128;
        break;
      case Screen.grid:
        hoverContainerPosition = h/2 - 55;
        break;
      case Screen.array:
        hoverContainerPosition = h/2 + 17;
        break;
      case Screen.search:
        hoverContainerPosition = h/2 + 53;
        break;
    }

    return Container(
      width: navBarWidth,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 30),
      decoration: Decorations.sideBar,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HoveringContainer(
            top: hoverContainerPosition,
          ),
          const Positioned.fill(
            right: 4,
            child: _IconButtons()),
        ],
      ),
    );
  }
}

class _HoveringContainer extends StatelessWidget {
  const _HoveringContainer({
    super.key,
    required this.top,
  });

  final double top;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: d200,
      curve: Curves.easeOutQuad,
      left: -3,
      top: top,
      child: Container(
        width: 4,
        height: iconButtonSize,
        decoration: Decorations.navBarHoverContainer,
      ),
    );
  }
}

class _IconButtons extends StatelessWidget {
  const _IconButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenPr>(
      builder: (context, screenPr, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MIconButton(
            onPressed: () {
              screenPr.setScreen('home');
            },
            isHighlighted: screenPr.state == Screen.home,
            icon: Icons.home_outlined,
          ),
          space30v,
          MIconButton(
            onPressed: () {
              screenPr.setScreen('grid');
            },
            isHighlighted: screenPr.state == Screen.grid,
            icon: Icons.grid_view,
          ),
          space30v,
          MIconButton(
            onPressed: () {
              screenPr.setScreen('array');
            },
            isHighlighted: screenPr.state == Screen.array,
            icon: Icons.sort,
          ),
          // space30v,
          // MIconButton(
          //   onPressed: () {
          //     screenPr.setScreen('search');
          //   },
          //   isHighlighted: screenPr.state == Screen.search,
          //   icon: Icons.search,
          // ),
        ],
      ),
    );
  }
}
