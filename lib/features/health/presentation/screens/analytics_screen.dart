import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../widgets/analytics_gauge.dart';
import '../widgets/mood_distribution_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Health Insights',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      // 1. Wrap the body in a RefreshIndicator
      body: RefreshIndicator(
        onRefresh: () => context.read<HealthProvider>().loadEntries(),
        displacement: 20,
        color: theme.colorScheme.primary,
        child: Consumer<HealthProvider>(
          builder: (context, provider, child) {
            final last7Entries = provider.entries.take(7).toList();

            if (last7Entries.isEmpty) {
              // Ensure the empty state is also scrollable so refresh works
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              // 2. Crucial: Set physics to AlwaysScrollable
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last 7 Days Summary",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: AnalyticsGauge(
                          label: "Sleep",
                          value: avgSleep,
                          goal: 8.0,
                          unit: "hrs",
                          icon: Icons.bedtime_rounded,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnalyticsGauge(
                          label: "Water",
                          value: avgWater,
                          goal: 3.0,
                          unit: "L",
                          icon: Icons.water_drop_rounded,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withOpacity(
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
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mood Distribution',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildInfoAlert(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Keep logging! More data provides more accurate health trends.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAnalytics(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 24),
          const Text(
            "Gathering Insights...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text("Log a few days to see your health patterns."),
        ],
      ),
    );
  }
}
