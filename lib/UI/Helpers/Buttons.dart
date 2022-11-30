import 'package:flutter/material.dart';

import '../../Globals/constants.dart';
import '../../Globals/decorations.dart';
import '../../Globals/styles.dart';

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
                  (index) => Shadow(color: secondary, blurRadius: index * 3),
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
  const MIconButton({
    super.key,
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
        scale: isHovering || widget.isHighlighted ? hoverScale : 1.0,
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
            icon: Icon(
              widget.icon,
              size: 22,
              color: widget.isHighlighted ? Colors.white : Colors.grey,
              shadows: List<Shadow>.generate(
                widget.isHighlighted
                    ? 4
                    : isHovering
                        ? 3
                        : 2,
                (index) => Shadow(
                    blurRadius: index * 3, color: secondary.withOpacity(0.75)),
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


class NavigationCard extends StatefulWidget {
  const NavigationCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isScreenHovering,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final ValueNotifier<bool> isScreenHovering;

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  
  final scaleFactor = 1.1;
  
  bool isHovering = false;
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        duration: _duration,
        curve: _curve,
        scale: isHovering ? scaleFactor : isTapped? 0.85: 1.0,
        child: GestureDetector(
          onTapDown: (_) => _setTapped(true),
          onTapCancel: () => _setTapped(false),
          onTapUp: (_) => _setTapped(false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: _duration,
            curve: _curve,
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: RadialGradient(
                colors: isHovering || isTapped
                    ? [
                        background.withOpacity(0.6),
                        Colors.purpleAccent,
                      ]
                    : [
                        background.withOpacity(0.6),
                        secondary100.withOpacity(0.4),
                      ],
                radius: 1.5,
              ),
            ),
            child: AnimatedScale(
              duration: _duration,
              curve: _curve,
              scale: isHovering ? 1.1 : 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 50,
                    color: isHovering || isTapped ? Colors.white : Colors.grey.shade600,
                    shadows: List<Shadow>.generate(
                      isHovering || isTapped ? 4 : 0,
                      (index) => Shadow(
                          blurRadius: index * 3,
                          color: secondary.withOpacity(0.75)),
                    ),
                  ),
                  Text(
                    widget.label,
                    style: isHovering || isTapped
                        ? Styles.neon()
                        : TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHovering(bool val) {
    setState(() {
      widget.isScreenHovering.value = isHovering = val;
    });
  }
  
  void _setTapped(bool val) {
    setState(() {
      isHovering = false;
      isTapped = val;
    });
  }
}

// enum _FABState {
//   searchbar,
//   searchButton,
//   backButton,
// }

// class FAB extends StatefulWidget {
//   const FAB({
//     super.key,
//   });

//   @override
//   State<FAB> createState() => FABState();
// }

// class FABState extends State<FAB> {
//   final int page = 1;

//   _FABState state = _FABState.searchButton;
//   bool isHovering = false;
//   double scale = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     final w = screenWidth(context);

//     return Positioned(
//       left: 30,
//       bottom: 30,
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onEnter: (_) {
//           _setScale(1.2);
//           _setHovering(true);
//         },
//         onExit: (_) {
//           _setScale(1.0);
//           _setHovering(false);
//         },
//         child: AnimatedScale(
//           duration: _duration,
//           curve: _curve,
//           scale: scale,
//           child: GestureDetector(
//             onTapDown: (_) =>_setScale(0.85),
//             onTapUp: (_) => _setScale(1.2),
//             onTap: () => _onTap(),
//             child: AnimatedSwitcher(
//               duration: d2000,
//               switchInCurve: _curve,
//               switchOutCurve: _curve,
//               transitionBuilder: (child, animation) => ScaleTransition(
//                 scale: animation,
//                 alignment: Alignment.centerLeft,
//                 child: child,
//               ),
//               child: Container(
//                 // width: _width,
//                 height: iconButtonSize,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   shape: _shape,
//                   borderRadius: _borderRadius,
//                   gradient: RadialGradient(radius: 1.5, colors: _colors),
//                 ),
//                 child: _child,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   double get _width {
//     switch (state) {
//       case _FABState.searchbar:
//         return 98 + iconButtonSize + 24;
//       default:
//         return iconButtonSize;
//     }
//   }

//   BorderRadius? get _borderRadius {
//     if (state == _FABState.searchbar) {
//       BorderRadius.circular(iconButtonSize / 2);
//     }
//     return null;
//   }

//   BoxShape get _shape {
//     switch (state) {
//       case _FABState.searchbar:
//         return BoxShape.rectangle;
//       default:
//         return BoxShape.circle;
//     }
//   }

//   List<Color> get _colors {
//     // if (state == _FABState.searchbar) {
//     //   return [secondary, secondary];
//     // }
//     if (isHovering) {
//       return [
//         secondary.withOpacity(0.75),
//         secondary,
//       ];
//     } else {
//       return [
//         secondary.withOpacity(0.3),
//         secondary.withOpacity(0.6),
//       ];
//     }
//   }

//   Widget get _child {
//     switch (state) {
//       case _FABState.searchButton:
//         return const Icon(
//           Icons.search,
//         );
//       case _FABState.backButton:
//         return const Icon(
//           Icons.keyboard_arrow_up,
//         );
//       case _FABState.searchbar:
//         return Row(
//           children: [
//             const Icon(
//               Icons.search,
//             ),
//             const SizedBox(
//               width: 120,
//               child: TextField(),
//             )
//           ],
//         );
//     }
//   }

//   void _setState(_FABState val) {
//     setState(() {
//       state = val;
//     });
//   }

//   void _onTap() {
//     switch (state) {
//       case _FABState.searchbar:
//         _setState(_FABState.searchButton);
//         break;
//       case _FABState.searchButton:
//         _setState(_FABState.searchbar);
//         break;
//       case _FABState.backButton:
//         _setState(_FABState.searchButton);
//         break;
//     }
//   }

//   void _setScale(double val) {
//     setState(() {
//       scale = val;
//     });
//   }

//   void _setHovering(bool val) {
//     setState(() {
//       isHovering = val;
//     });
//   }
// }
