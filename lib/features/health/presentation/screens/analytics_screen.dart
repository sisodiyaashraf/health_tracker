import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/health_provider.dart';
import '../widgets/analytics_gauge.dart';
import '../widgets/mood_distribution_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  // Dark Mode Palette
  static const Color darkBgBase = Color(0xFF0A0A0B);
  static const Color darkIndigoDepth = Color(0xFF1A122E);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBgBase : theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Health Insights',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? darkBgBase : theme.colorScheme.surface,
              isDark
                  ? darkIndigoDepth.withOpacity(0.4)
                  : theme.colorScheme.primaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => context.read<HealthProvider>().loadEntries(),
          displacement: 20,
          color: AppTheme.brandPurple,
          child: Consumer<HealthProvider>(
            builder: (context, provider, child) {
              final last7Entries = provider.entries.take(7).toList();

              if (last7Entries.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyAnalytics(context),
                  ),
                );
              }

              final avgSleep = provider.avgSleep;
              final avgWater = provider.avgWater;

              final moodCounts = {'Good': 0, 'Okay': 0, 'Bad': 0};
              for (var e in last7Entries) {
                moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last 7 Days Summary",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassGauge(
                            context,
                            AnalyticsGauge(
                              label: "Sleep",
                              value: avgSleep,
                              goal: 8.0,
                              unit: "hrs",
                              icon: Icons.bedtime_rounded,
                              color: Colors.indigoAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGlassGauge(
                            context,
                            AnalyticsGauge(
                              label: "Water",
                              value: avgWater,
                              goal: 3.0,
                              unit: "L",
                              icon: Icons.water_drop_rounded,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Refined Mood Distribution Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : theme.colorScheme.outlineVariant.withOpacity(
                                  0.4,
                                ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.face_retouching_natural_rounded,
                                color: AppTheme.brandPurple,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Mood Distribution',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ...moodCounts.entries.map(
                            (entry) => MoodDistributionBar(
                              label: entry.key,
                              count: entry.value,
                              total: last7Entries.length,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    _buildInfoAlert(context),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlassGauge(BuildContext context, Widget gauge) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
      ),
      child: gauge,
    );
  }

  Widget _buildInfoAlert(BuildContext context) {
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

  Widget _buildEmptyAnalytics(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 100,
            color: isDark
                ? Colors.white10
                : Theme.of(context).colorScheme.outlineVariant,
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
          const Text("Log a few days to see your health patterns."),
        ],
      ),
    );
  }
}
