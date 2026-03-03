import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/health_entry.dart';
import '../widgets/health_metric_row.dart';

class EntryDetailScreen extends StatelessWidget {
  final HealthEntry entry;

  const EntryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 1. Consistent Background Gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 2. Fixed Visibility AppBar
            SliverAppBar.large(
              pinned: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: theme.colorScheme.surface,
              title: Text(
                DateFormat('MMMM d, yyyy').format(entry.date),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 3. Header Section with Parallax-style Hero
                  Center(
                    child: Column(
                      children: [
                        Hero(
                          tag: 'mood-${entry.date.toIso8601String()}',
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30),
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
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // 4. Metrics Row using Glassmorphism
                  Row(
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
                  ),

                  const SizedBox(height: 40),

                  // 5. Refined Notes Section
                  const Text(
                    "Your Reflections",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      (entry.note == null || entry.note!.isEmpty)
                          ? "No notes recorded for this day."
                          : entry.note!,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white),
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
