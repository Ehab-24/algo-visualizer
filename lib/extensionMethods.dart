import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';

extension ExOnWidget on Widget {
  Widget withScaleOnHover([double scaleFactor = 1.05]) =>
      ScaleOnHover(child: this, scaleFactor: scaleFactor);
}

class ScaleOnHover extends StatefulWidget {
  const ScaleOnHover({
    super.key,
    required this.child,
    required this.scaleFactor,
  });

  final Widget child;
  final double scaleFactor;

  @override
  State<ScaleOnHover> createState() => _ScaleOnHoverState();
}

class _ScaleOnHoverState extends State<ScaleOnHover> {

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        curve: Curves.easeOutCubic,
        scale: isHovering ? widget.scaleFactor : 1.0,
        duration: d200,
        child: widget.child,
      ),
    );
  }

  void _setHovering(bool val) {
    setState(() {
      isHovering = val;
    });
  }
}
