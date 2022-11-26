import 'package:flutter/material.dart';

import 'constants.dart';

class Decorations {
  static BoxDecoration elevatedButton = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(blurRadius: 6, color: Colors.black, offset: Offset(0.0, 5))
    ],
  );
  static const BoxDecoration iconButton = BoxDecoration(
    shape: BoxShape.circle,
    // color: color,
    // boxShadow: [
    //   BoxShadow(blurRadius: 6, color: Colors.black54, offset: Offset(0.0, 5))
    // ],
  );
  static const BoxDecoration navBarHoverContainer = BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.85),
      borderRadius: BorderRadius.only(
        topRight: Radius.elliptical(1, 24),
        bottomRight: Radius.elliptical(1, 24),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 6,
          color: secondary,
        ),
      ]);
  static const BoxDecoration sideBar = BoxDecoration(
    color: primary,
    boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black)],
  );
  static BoxDecoration sideBarProperties = BoxDecoration(
    color: background.withOpacity(0.2),
    borderRadius: BorderRadius.circular(16),
  );
}
