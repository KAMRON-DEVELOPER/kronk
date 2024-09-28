import 'package:flutter/material.dart';

class AvatarPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  AvatarPainter(
      {required this.borderColor, required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..arcToPoint(
        Offset(size.width, size.height / 2),
        radius: Radius.circular(size.width / 2),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
