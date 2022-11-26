
import 'package:flutter/material.dart';

import '../../Globals/constants.dart';
import '../../Globals/decorations.dart';

const Curve _curve = Curves.easeOutCubic;
const Duration _duration = d200;

class MElevatedButton extends StatefulWidget {
  const MElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  State<MElevatedButton> createState() => _MElevatedButtonState();
}

class _MElevatedButtonState extends State<MElevatedButton> {
  final double hoverScale = 1.1;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        curve: _curve,
        scale: isHovering ? hoverScale : 1.0,
        duration: _duration,
        child: DecoratedBox(
          decoration: Decorations.elevatedButton,
          child: TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
                backgroundColor: background,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 16,
                shadows: List<Shadow>.generate(
                  isHovering ? 7 : 3,
                  (index) =>
                      Shadow(color: secondary, blurRadius: index * 3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHovering(bool val) {
    setState(() {
      isHovering = val;
    });
  }
}

class MIconButton extends StatefulWidget {
  const MIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.isHighlighted,
    });

  final VoidCallback onPressed;
  final IconData icon;
  final bool isHighlighted;

  @override
  State<MIconButton> createState() => _MIconButtonState();
}

class _MIconButtonState extends State<MIconButton> {
  final double hoverScale = 1.2;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        scale: isHovering || widget.isHighlighted? hoverScale : 1.0,
        duration: _duration,
        curve: _curve,
        child: SizedBox(
          width: iconButtonSize / hoverScale,
          height: iconButtonSize / hoverScale,
          child: IconButton(
            onPressed: widget.onPressed,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(widget.icon,
                size: 22,
                color: widget.isHighlighted
                ? Colors.white: Colors.grey,
                shadows: List<Shadow>.generate(
                  widget.isHighlighted? 4 : 
                  isHovering? 3 : 2,
                  (index) =>
                      Shadow(blurRadius: index * 3, color: secondary.withOpacity(0.75)),
                )),
          ),
        ),
      ),
    );
  }

  void _setHovering(bool val) {
    setState(() {
      isHovering = val;
    });
  }
}
