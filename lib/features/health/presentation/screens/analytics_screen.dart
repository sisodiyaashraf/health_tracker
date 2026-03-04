import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/widgets/analytics_widgets.dart/analytics_status_views.dart';
import 'package:health_tracker/features/health/presentation/widgets/analytics_widgets.dart/analytics_summary_gauges.dart';
import 'package:health_tracker/features/health/presentation/widgets/analytics_widgets.dart/mood_distribution_card.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/health_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
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
          color: AppTheme.brandPurple,
          child: Consumer<HealthProvider>(
            builder: (context, provider, child) {
              final last7Entries = provider.entries.take(7).toList();

              if (last7Entries.isEmpty) {
                return const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: AnalyticsEmptyState(),
                );
              }

              final moodCounts = {'Good': 0, 'Okay': 0, 'Bad': 0};
              for (var e in last7Entries)
                moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;

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
                    AnalyticsSummaryGauges(
                      avgSleep: provider.avgSleep,
                      avgWater: provider.avgWater,
                    ),
                    const SizedBox(height: 32),
                    MoodDistributionCard(
                      moodCounts: moodCounts,
                      totalEntries: last7Entries.length,
                    ),
                    const SizedBox(height: 32),
                    const AnalyticsInfoAlert(),
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
}
