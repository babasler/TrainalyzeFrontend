import 'package:flutter/material.dart';
import '../../../enviroment/env.dart';
import '../models/statistics_models.dart';

class TrainingHeatmapWidget extends StatelessWidget {
  final List<TrainingHeatmapData> data;
  final Function(DateTime)? onDayTapped;

  const TrainingHeatmapWidget({
    super.key,
    required this.data,
    this.onDayTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Trainings-Aktivität',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHeatmapGrid(),
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid() {
    // Get current year data
    DateTime now = DateTime.now();
    DateTime yearStart = DateTime(now.year, 1, 1);

    // Calculate weeks in year
    int weeksInYear = ((now.difference(yearStart).inDays) / 7).ceil() + 1;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weeksInYear,
        itemBuilder: (context, weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Column(
              children: List.generate(7, (dayIndex) {
                DateTime currentDate = yearStart.add(
                  Duration(days: weekIndex * 7 + dayIndex),
                );

                if (currentDate.isAfter(now)) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }

                TrainingHeatmapData? dayData = data.firstWhere(
                  (d) =>
                      d.date.day == currentDate.day &&
                      d.date.month == currentDate.month,
                  orElse: () =>
                      TrainingHeatmapData(date: currentDate, intensity: 0),
                );

                return GestureDetector(
                  onTap: () => onDayTapped?.call(currentDate),
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: dayData.intensity > 0
                          ? AppColors.primary
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Text(
          'Kein Training',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Training absolviert',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
      ],
    );
  }
}

class MiniProgressChart extends StatelessWidget {
  final List<ProgressPoint> data;
  final String exerciseName;
  final ProgressTrend trend;
  final VoidCallback? onTap;

  const MiniProgressChart({
    super.key,
    required this.data,
    required this.exerciseName,
    required this.trend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getTrendColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exerciseName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getTrendColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTrendIcon(),
                    size: 12,
                    color: _getTrendColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: CustomPaint(
                size: const Size(double.infinity, 40),
                painter: MiniChartPainter(data, _getTrendColor()),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.last.weight.toInt()}kg',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                ),
                Text(
                  _getTrendText(),
                  style: TextStyle(
                    color: _getTrendColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrendColor() {
    switch (trend) {
      case ProgressTrend.improvement:
        return Colors.green;
      case ProgressTrend.stagnation:
        return Colors.orange;
      case ProgressTrend.decline:
        return Colors.red;
    }
  }

  IconData _getTrendIcon() {
    switch (trend) {
      case ProgressTrend.improvement:
        return Icons.trending_up;
      case ProgressTrend.stagnation:
        return Icons.trending_flat;
      case ProgressTrend.decline:
        return Icons.trending_down;
    }
  }

  String _getTrendText() {
    switch (trend) {
      case ProgressTrend.improvement:
        return 'Fortschritt';
      case ProgressTrend.stagnation:
        return 'Stagnation';
      case ProgressTrend.decline:
        return 'Rückgang';
    }
  }
}

class MiniChartPainter extends CustomPainter {
  final List<ProgressPoint> data;
  final Color color;

  MiniChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Find min/max values
    double minWeight = data
        .map((p) => p.weight)
        .reduce((a, b) => a < b ? a : b);
    double maxWeight = data
        .map((p) => p.weight)
        .reduce((a, b) => a > b ? a : b);

    if (minWeight == maxWeight) {
      maxWeight += 5; // Avoid division by zero
    }

    // Create path
    Path linePath = Path();
    Path fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      double x = (i / (data.length - 1)) * size.width;
      double y =
          size.height -
          ((data[i].weight - minWeight) / (maxWeight - minWeight)) *
              size.height;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class QuickStatCardWidget extends StatelessWidget {
  final QuickStatCard stat;

  const QuickStatCardWidget({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stat.color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stat.icon, color: stat.color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stat.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.subtitle,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 11),
          ),
          if (stat.trend != null) ...[
            const SizedBox(height: 6),
            Text(
              stat.trend!,
              style: TextStyle(
                color: stat.color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PersonalRecordsList extends StatelessWidget {
  final List<PersonalRecord> records;

  const PersonalRecordsList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Keine Personal Records gefunden',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    // Sort by date (newest first)
    List<PersonalRecord> sortedRecords = List.from(records)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Neueste Personal Records',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...sortedRecords.take(5).map((record) => _buildRecordItem(record)),
      ],
    );
  }

  Widget _buildRecordItem(PersonalRecord record) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: Colors.amber, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record.type,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.weight.toInt()}kg × ${record.reps} • ${_formatDate(record.date)}',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    int daysDiff = now.difference(date).inDays;

    if (daysDiff == 0) return 'Heute';
    if (daysDiff == 1) return 'Gestern';
    if (daysDiff < 7) return 'vor ${daysDiff}d';
    if (daysDiff < 30) return 'vor ${(daysDiff / 7).round()}w';

    return '${date.day}.${date.month}.${date.year}';
  }
}
