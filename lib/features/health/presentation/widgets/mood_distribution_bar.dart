import 'package:flutter/material.dart';

class MoodDistributionBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;

  const MoodDistributionBar({
    super.key,
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getMoodColor(label);
    double percent = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0, end: percent),
        builder: (context, animValue, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "$count days",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: animValue,
                  minHeight: 14,
                  backgroundColor: theme.colorScheme.surface,
                  color: color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getMoodColor(String mood) {
    if (mood == 'Good') return const Color(0xFF10B981);
    if (mood == 'Okay') return const Color(0xFFF59E0B);
    return const Color(0xFFF43F5E);
  }
}
