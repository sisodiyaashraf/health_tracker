import 'package:flutter/material.dart';

/// A custom painter that draws a subtle background grid pattern.
/// Works dynamically with Light and Dark mode.
class GridPainter extends CustomPainter {
  final Color color;

  // Constructor with a default value to prevent 'required parameter' errors
  GridPainter({this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
          .withOpacity(0.15) // Adjust opacity for subtlety
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // The gap between grid lines
    const double step = 40.0;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    // Repaint only if the color changes (e.g., during theme toggle)
    return oldDelegate.color != color;
  }
}
