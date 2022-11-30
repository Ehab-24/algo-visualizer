import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  CurvedPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, 0,
        size.width * 0.5, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2,
        size.width * 1.0, size.height * 0.1);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
