import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/GridPainter.dart';

class HomeBackgroundGrid extends StatelessWidget {
  const HomeBackgroundGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: Opacity(
        opacity: isDark ? 0.08 : 0.04,
        child: CustomPaint(
          painter: GridPainter(
            color: isDark ? const Color(0xFF3F3F46) : Colors.grey,
          ),
        ),
      ),
    );
  }
}
