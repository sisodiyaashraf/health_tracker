import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/app_theme.dart';
import 'package:health_tracker/features/health/presentation/screens/entry_detail_screen.dart';
import 'package:health_tracker/features/health/presentation/widgets/entry_detail_widgets.dart/health_metric_row.dart';
import 'package:intl/intl.dart';

class HealthEntryCard extends StatelessWidget {
  final dynamic entry;
  final int index;

  const HealthEntryCard({super.key, required this.entry, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 60)),
      curve: Curves.easeOutQuart,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EntryDetailScreen(entry: entry)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1C1C1E).withOpacity(0.8)
                  : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.6 : 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _MoodBadge(mood: entry.mood),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM d').format(entry.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Feeling ${entry.mood}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HealthMetricRow(
                        icon: Icons.bedtime_rounded,
                        value: '${entry.sleepHours}h',
                        label: 'Sleep',
                        accentColor: AppTheme.brandPurple,
                      ),
                      HealthMetricRow(
                        icon: Icons.water_drop_rounded,
                        value: '${entry.waterIntake}L',
                        label: 'Water',
                        accentColor: Colors.lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  final String mood;
  const _MoodBadge({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getMoodColor(mood).withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Text(_getMoodEmoji(mood), style: const TextStyle(fontSize: 22)),
    );
  }

  Color _getMoodColor(String mood) {
    if (mood == 'Good') return AppTheme.emeraldGreen;
    if (mood == 'Bad') return AppTheme.roseRed;
    return Colors.orangeAccent;
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Good':
        return '😊';
      case 'Okay':
        return '😐';
      case 'Bad':
        return '😔';
      default:
        return '🤔';
    }
  }
}
