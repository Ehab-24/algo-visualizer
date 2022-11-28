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
        throw 'No navBar found for Home Screen.';
      case Screen.grid:
        hoverContainerPosition = h / 2 - 52;
        break;
      case Screen.array:
        hoverContainerPosition = h / 2 + 21;
        break;
      case Screen.explanation:
        hoverContainerPosition = h / 2 + 90;
        break;
    }

    return AnimatedSize(
      duration: d800,
      reverseDuration: d800,
      curve: Curves.easeOutQuad,
      alignment: Alignment.centerLeft,
      child: Container(
        width: screen == Screen.home ? 0 : navBarWidth,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: screen == Screen.explanation ? Colors.transparent : primary,
          boxShadow: screen == Screen.explanation
              ? null
              : const [
                  BoxShadow(blurRadius: 6, color: Colors.black),
                ]
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _HoveringContainer(
              top: hoverContainerPosition,
            ),
            const Positioned.fill(right: 4, child: _IconButtons()),
          ],
        ),
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
        children: [
          MIconButton(
            onPressed: () {
              screenPr.setScreen('home');
            },
            isHighlighted: false,
            icon: Icons.arrow_back,
          ),
          const Spacer(),
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
          //     screenPr.setScreen('explanation');
          //   },
          //   isHighlighted: screenPr.state == Screen.explanation,
          //   icon: Icons.library_books_outlined,
          // ),
          const Spacer(),
        ],
      ),
    );
  }
}
