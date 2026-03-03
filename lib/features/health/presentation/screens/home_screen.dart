import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/GridPainter.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/health_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/health_metric_row.dart';
import 'add_entry_screen.dart';
import 'analytics_screen.dart';
import 'entry_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Premium Dark Mode Color Palette
    const Color darkBgBase = Color(0xFF0A0A0B); // Deepest Black
    const Color darkIndigoDepth = Color(0xFF1A122E); // Purple tint for depth

    return Scaffold(
      backgroundColor: isDark ? darkBgBase : theme.colorScheme.surface,
      body: Container(
        // 1. Updated: Multi-layered Gradient for Dark Mode Depth
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? darkBgBase : theme.colorScheme.surface,
              isDark
                  ? darkIndigoDepth.withOpacity(0.4)
                  : theme.colorScheme.primaryContainer.withOpacity(0.25),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 2. Updated: Subtle Indigo Grid for Dark Mode
            Positioned.fill(
              child: Opacity(
                opacity: isDark ? 0.08 : 0.04,
                child: CustomPaint(
                  painter: GridPainter(
                    color: isDark ? const Color(0xFF3F3F46) : Colors.grey,
                  ),
                ),
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
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'My Health',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    surfaceTintColor: Colors.transparent,
                    actions: [
                      _buildThemeToggle(context, theme),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, left: 8),
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
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
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
      floatingActionButton: _buildModernFAB(context),
    );
  }

  Widget _buildHeaderAction(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
      ),
      child: Hero(
        tag: 'analytics_icon',
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Icon(
            Icons.insights_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildModernFAB(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEntryScreen()),
      ),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 6,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      icon: const Icon(Icons.add_rounded, size: 24),
      label: const Text(
        'New Entry',
        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark =
            themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                theme.brightness == Brightness.dark);

        return IconButton(
          onPressed: () => themeProvider.toggleTheme(!isDark),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              key: ValueKey(isDark),
              color: isDark ? Colors.orangeAccent : theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard(BuildContext context, dynamic entry, int index) {
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
            // 3. Updated: Glassmorphic Surface for Dark Mode
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
            // 4. Updated: Edge-Lighting effect for Dark Mode contrast
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
    );
  }

  Widget _buildMoodIcon(dynamic entry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getMoodColor(entry.mood).withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        _getMoodEmoji(entry.mood),
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_rounded,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Health Journey',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          Text(
            'Log your first day to start tracking.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
