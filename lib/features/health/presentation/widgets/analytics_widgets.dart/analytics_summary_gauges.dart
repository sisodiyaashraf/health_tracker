import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/widgets/analytics_widgets.dart/analytics_gauge.dart';

class AnalyticsSummaryGauges extends StatelessWidget {
  final double avgSleep;
  final double avgWater;

  const AnalyticsSummaryGauges({
    super.key,
    required this.avgSleep,
    required this.avgWater,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
