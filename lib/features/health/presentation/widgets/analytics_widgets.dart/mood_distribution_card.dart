import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/app_theme.dart';
import 'package:health_tracker/features/health/presentation/widgets/analytics_widgets.dart/mood_distribution_bar.dart';

class MoodDistributionCard extends StatelessWidget {
  final Map<String, int> moodCounts;
  final int totalEntries;

  const MoodDistributionCard({
    super.key,
    required this.moodCounts,
    required this.totalEntries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : theme.colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.face_retouching_natural_rounded,
                color: AppTheme.brandPurple,
              ),
              const SizedBox(width: 12),
              const Text(
                'Mood Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...moodCounts.entries.map(
            (entry) => MoodDistributionBar(
              label: entry.key,
              count: entry.value,
              total: totalEntries,
            ),
          ),
        ],
      ),
    );
  }
}
