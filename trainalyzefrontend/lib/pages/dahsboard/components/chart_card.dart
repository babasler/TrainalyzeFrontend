import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';

enum TimeRange {
  week('7T'),
  month('30T'),
  quarter('90T'),
  year('1J');

  const TimeRange(this.label);
  final String label;
}

class ChartCard extends StatefulWidget {
  final String title;
  final Widget Function(TimeRange timeRange) chartBuilder;
  final TimeRange initialTimeRange;

  const ChartCard({
    super.key,
    required this.title,
    required this.chartBuilder,
    this.initialTimeRange = TimeRange.month,
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  late TimeRange _selectedTimeRange;

  @override
  void initState() {
    super.initState();
    _selectedTimeRange = widget.initialTimeRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header mit Titel und Zeitauswahl
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: TimeRange.values.map((timeRange) {
                    final isSelected = timeRange == _selectedTimeRange;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeRange = timeRange;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          timeRange.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart
          SizedBox(height: 200, child: widget.chartBuilder(_selectedTimeRange)),
        ],
      ),
    );
  }
}
