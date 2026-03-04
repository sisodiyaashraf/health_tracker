import 'package:flutter/material.dart';

class AnalyticsGauge extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final String unit;
  final IconData icon;
  final Color color;

  const AnalyticsGauge({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 85,
                width: 85,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: color.withOpacity(0.1),
                  color: color,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Icon(icon, color: color, size: 30),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "${value.toStringAsFixed(1)}$unit",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          Text(
            "Avg $label",
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
