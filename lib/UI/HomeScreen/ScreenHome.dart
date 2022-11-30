// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../../Globals/constants.dart';
import 'BodyHome.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});


  @override
  Widget build(BuildContext context) {
  final hoverTransform = Matrix4.identity()..scale(1.0, 1.0);
  final defaultTransform = Matrix4.identity()..scale(1.15, 1.15);
    
    return ValueListenableBuilder<bool>(
      valueListenable: isScreenHovering,
      builder: (context, isHovering, child) => Stack(
        children: [
          AnimatedContainer(
            duration: d400,
            curve: Curves.easeOutQuad,
            transformAlignment: Alignment.center,
            transform: isHovering ? hoverTransform : defaultTransform,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/neon_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedContainer(
            duration: d200,
            curve: Curves.easeOutQuad,
            color: isHovering
                ? Colors.black.withOpacity(0.8)
                : Colors.black.withOpacity(0.6),
            child: child,
          ),
        ],
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: BodyHome(),
      ),
    );
  }
}
