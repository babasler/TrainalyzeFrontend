import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/dahsboard/components/chart_card.dart';

// Dummy Chart Widgets - hier würden später echte Charts integriert werden
class DummyLineChart extends StatelessWidget {
  final TimeRange timeRange;
  final String dataType;

  const DummyLineChart({
    super.key,
    required this.timeRange,
    required this.dataType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, color: AppColors.primary, size: 40),
            const SizedBox(height: 8),
            Text(
              '$dataType Chart',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Zeitraum: ${timeRange.label}',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyBarChart extends StatelessWidget {
  final TimeRange timeRange;
  final String dataType;

  const DummyBarChart({
    super.key,
    required this.timeRange,
    required this.dataType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: AppColors.primary, size: 40),
            const SizedBox(height: 8),
            Text(
              '$dataType Chart',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Zeitraum: ${timeRange.label}',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyHeatmapChart extends StatelessWidget {
  final TimeRange timeRange;
  final String dataType;

  const DummyHeatmapChart({
    super.key,
    required this.timeRange,
    required this.dataType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_view_month, color: AppColors.primary, size: 40),
            const SizedBox(height: 8),
            Text(
              '$dataType Heatmap',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Zeitraum: ${timeRange.label}',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
