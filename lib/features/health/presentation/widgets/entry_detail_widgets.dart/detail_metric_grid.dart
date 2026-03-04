import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/app_theme.dart';
import 'package:health_tracker/features/health/data/models/health_entry.dart';
import 'package:health_tracker/features/health/presentation/widgets/entry_detail_widgets.dart/health_metric_row.dart';

class DetailMetricGrid extends StatelessWidget {
  final HealthEntry entry;

  const DetailMetricGrid({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDetailTile(
          context,
          Icons.bedtime_rounded,
          "${entry.sleepHours}h",
          "Sleep Total",
          AppTheme.brandPurple,
        ),
        const SizedBox(width: 16),
        _buildDetailTile(
          context,
          Icons.water_drop_rounded,
          "${entry.waterIntake}L",
          "Hydration",
          Colors.lightBlue,
        ),
      ],
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
          ),
        ),
        child: HealthMetricRow(
          icon: icon,
          value: value,
          label: label,
          accentColor: color,
        ),
      ),
    );
  }
}
