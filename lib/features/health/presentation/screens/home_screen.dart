import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/health_provider.dart';
import '../widgets/health_metric_row.dart';
import 'add_entry_screen.dart';
import 'analytics_screen.dart';
import 'entry_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = AppTheme.brandPurple;

    return Scaffold(
      // 1. Dynamic Background with Gradient and Pattern
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 2. Subtle geometric background pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(painter: GridPainter()),
              ),
            ),

            RefreshIndicator(
              displacement: 100,
              onRefresh: () => context.read<HealthProvider>().loadEntries(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar.large(
                    backgroundColor: Colors.transparent, // Glass effect
                    title: const Text(
                      'My Health',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    surfaceTintColor: Colors.transparent,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildHeaderAction(context, theme),
                      ),
                    ],
                  ),

                  Consumer<HealthProvider>(
                    builder: (context, provider, _) {
                      if (provider.entries.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(context),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          120,
                        ), // More breathing room
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final entry = provider.entries[index];
                            return _buildAnimatedCard(context, entry, index);
                          }, childCount: provider.entries.length),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(context, brandColor),
    );
  }

  // 3. Modern Glass-style Header Action
  Widget _buildHeaderAction(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
      ),
      child: Hero(
        tag: 'analytics_icon',
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Icon(
            Icons.insert_chart_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, dynamic entry, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 80)),
      curve: Curves.easeOutBack, // Playful entrance
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildModernCard(context, entry),
    );
  }

  Widget _buildModernCard(BuildContext context, dynamic entry) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EntryDetailScreen(entry: entry)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(32), // Softer corners
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildMoodIcon(entry),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d').format(entry.date),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
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
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey,
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
    );
  }

  Widget _buildMoodIcon(dynamic entry) {
    return Hero(
      tag: 'mood-${entry.date.toIso8601String()}',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getMoodColor(entry.mood).withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: Text(
            _getMoodEmoji(entry.mood),
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFAB(BuildContext context, Color color) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEntryScreen()),
      ),
      backgroundColor: color,
      foregroundColor: Colors.white,
      elevation: 8,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: const Icon(Icons.add_rounded, size: 28),
      label: const Text(
        'New Entry',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Health Journey',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const Text(
            'Log your first day to start tracking.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
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

// Reusing your GridPainter for background depth
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
