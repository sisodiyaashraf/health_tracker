import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/data/models/health_entry.dart';

class DetailMoodHeader extends StatelessWidget {
  final HealthEntry entry;

  const DetailMoodHeader({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'mood-${entry.date.toIso8601String()}',
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.white30,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _getMoodEmoji(entry.mood),
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "You felt ${entry.mood}",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
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
