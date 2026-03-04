import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/app_theme.dart';

class AnalyticsInfoAlert extends StatelessWidget {
  const AnalyticsInfoAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.brandPurple.withOpacity(0.15)
            : theme.colorScheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppTheme.brandPurple.withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: isDark ? Colors.amberAccent : theme.colorScheme.primary,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Keep logging! More data provides more accurate health trends.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsEmptyState extends StatelessWidget {
  const AnalyticsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 100,
            color: isDark ? Colors.white10 : theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 24),
          Text(
            "Gathering Insights...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white70 : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Log a few days to see your health patterns.",
            style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
          ),
        ],
      ),
    );
  }
}
