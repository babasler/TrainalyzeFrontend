import 'package:flutter/material.dart';
import 'models/statistics_models.dart';
import '../../enviroment/env.dart';

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint(this.date, this.value);
}

class DetailedChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color color;
  final String type;

  DetailedChartPainter(this.data, this.color, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      // Draw placeholder for empty data
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Keine Daten verfügbar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (size.width - textPainter.width) / 2,
          (size.height - textPainter.height) / 2,
        ),
      );
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    // Calculate safe bounds
    final values = data.map((p) => p.value).where((v) => v.isFinite).toList();
    final dates = data
        .map((p) => p.date.millisecondsSinceEpoch.toDouble())
        .toList();

    if (values.isEmpty || dates.isEmpty) return;

    final minX = dates.reduce((a, b) => a < b ? a : b);
    final maxX = dates.reduce((a, b) => a > b ? a : b);
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);

    final padding = 40.0; // Increased padding for labels
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2);

    // Prevent division by zero
    final xRange = maxX - minX;
    final yRange = maxY - minY;

    if (xRange == 0 || yRange == 0 || !xRange.isFinite || !yRange.isFinite) {
      return;
    }

    // Draw data points and lines
    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final x =
          padding +
          (point.date.millisecondsSinceEpoch - minX) / xRange * chartWidth;
      final y = padding + (1 - (point.value - minY) / yRange) * chartHeight;

      if (x.isFinite && y.isFinite) {
        points.add(Offset(x, y));

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw grid lines and axis labels
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(color: Colors.white, fontSize: 10);

    // Horizontal grid lines with Y-axis labels
    for (int i = 0; i <= 4; i++) {
      final y = padding + (i / 4) * chartHeight;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );

      // Y-axis labels (values)
      final value = maxY - (i / 4) * (maxY - minY);
      final textPainter = TextPainter(
        text: TextSpan(text: '${value.toInt()}', style: labelStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    // Vertical lines with X-axis labels (dates)
    for (int i = 0; i <= 3; i++) {
      final x = padding + (i / 3) * chartWidth;

      // Draw vertical line
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, size.height - padding),
        gridPaint,
      );

      // X-axis labels (dates)
      if (i < data.length) {
        final dateIndex = ((i / 3) * (data.length - 1)).round().clamp(
          0,
          data.length - 1,
        );
        final date = data[dateIndex].date;
        final dateText = '${date.day}.${date.month}';

        final textPainter = TextPainter(
          text: TextSpan(text: dateText, style: labelStyle),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 15),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  bool _isLoading = true;
  List<ExerciseProgressData> _allExercises = [];
  ExerciseProgressData? _selectedExercise;
  String _selectedTimeRange = '30';
  String _selectedParameter = 'volume'; // 'volume', 'max_weight', or 'reps'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _allExercises = StatisticsDataProvider.getAllExercises();
      _selectedExercise = _allExercises.first;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Übungsdetails',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Lade Übungsdetails...',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Selection Controls
          _buildSelectionControls(),

          const SizedBox(height: 16),

          // Main Chart
          if (_selectedExercise != null) _buildMainChart(),

          const SizedBox(height: 24),

          // Key Statistics
          if (_selectedExercise != null) _buildKeyStatistics(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSelectionControls() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Selection
          Row(
            children: [
              Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Übung',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedExercise?.exerciseId,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: Colors.white),
                items: _allExercises.map((exercise) {
                  return DropdownMenuItem<String>(
                    value: exercise.exerciseId,
                    child: Text(exercise.exerciseName),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedExercise = _allExercises.firstWhere(
                        (e) => e.exerciseId == newValue,
                      );
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Time Range Selection
          Row(
            children: [
              Icon(Icons.date_range, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Zeitraum',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTimeRangeButton('7', '7 Tage'),
              const SizedBox(width: 8),
              _buildTimeRangeButton('30', '30 Tage'),
              const SizedBox(width: 8),
              _buildTimeRangeButton('90', '90 Tage'),
              const SizedBox(width: 8),
              _buildTimeRangeButton('365', '1 Jahr'),
            ],
          ),

          const SizedBox(height: 20),

          // Parameter Selection
          Row(
            children: [
              Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Parameter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                children: [
                  _buildParameterButton('volume', 'Gesamtvolumen'),
                  const SizedBox(width: 8),
                  _buildParameterButton('max_weight', 'Max. Gewicht'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildParameterButton('reps', 'Wiederholungen'),
                  const SizedBox(width: 8),
                  Expanded(child: Container()), // Empty space to balance layout
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Info: Welcher Parameter wird angezeigt
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedParameter == 'volume'
                      ? Icons.bar_chart
                      : _selectedParameter == 'max_weight'
                      ? Icons.fitness_center
                      : Icons.repeat,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedParameter == 'volume'
                      ? 'Gesamtvolumen (kg)'
                      : _selectedParameter == 'max_weight'
                      ? 'Maximales Gewicht (kg)'
                      : 'Wiederholungen (Wdh)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(String value, String label) {
    bool isSelected = _selectedTimeRange == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTimeRange = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterButton(String value, String label) {
    bool isSelected = _selectedParameter == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedParameter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _selectedParameter == 'volume'
                    ? 'Gesamtvolumen'
                    : _selectedParameter == 'max_weight'
                    ? 'Maximales Gewicht'
                    : 'Wiederholungen',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _getTrendIcon(_getFilteredData()),
                color: _getChangeColor(_getFilteredData()),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_selectedExercise!.exerciseName} • ${_getTimeRangeLabel()}',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250, // Increased height for axis labels
            child: CustomPaint(
              size: const Size(double.infinity, 250),
              painter: DetailedChartPainter(
                _getFilteredData(),
                _selectedParameter == 'volume'
                    ? Colors.green
                    : _selectedParameter == 'max_weight'
                    ? Colors.blue
                    : Colors.orange,
                _selectedParameter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyStatistics() {
    final filteredData = _getFilteredData();
    if (filteredData.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Statistiken',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Aktueller Wert:',
            '${_getCurrentValue(filteredData)} ${_getUnit()}',
          ),
          _buildStatRow(
            'Durchschnittswert:',
            '${_getAverageValue(filteredData)} ${_getUnit()}',
          ),
          _buildStatRow(
            'Höchstwert:',
            '${_getMaxValue(filteredData)} ${_getUnit()}',
            valueColor: Colors.green,
          ),
          _buildStatRow(
            'Niedrigster Wert:',
            '${_getMinValue(filteredData)} ${_getUnit()}',
            valueColor: Colors.orange,
          ),
          _buildStatRowWithIcon(
            'Veränderung:',
            '${_getChangePercentage(filteredData)}%',
            _getTrendIcon(filteredData),
            _getChangeColor(filteredData),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textPrimary)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRowWithIcon(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textPrimary)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeRangeLabel() {
    switch (_selectedTimeRange) {
      case '7':
        return 'Letzte 7 Tage';
      case '30':
        return 'Letzte 30 Tage';
      case '90':
        return 'Letzte 90 Tage';
      case '365':
        return 'Letztes Jahr';
      default:
        return 'Letzte 30 Tage';
    }
  }

  String _getUnit() {
    switch (_selectedParameter) {
      case 'volume':
        return 'kg';
      case 'max_weight':
        return 'kg';
      case 'reps':
        return 'Wdh';
      default:
        return 'kg';
    }
  }

  List<ChartDataPoint> _getFilteredData() {
    if (_selectedExercise == null) return [];

    final days = int.parse(_selectedTimeRange);
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    switch (_selectedParameter) {
      case 'volume':
        // Volume data from existing VolumePoint data
        return _selectedExercise!.volumeData
            .where((v) => v.date.isAfter(cutoffDate))
            .map((v) => ChartDataPoint(v.date, v.totalVolume))
            .toList();
      case 'max_weight':
        // Max weight data from ProgressPoint data
        return _selectedExercise!.dataPoints
            .where((p) => p.date.isAfter(cutoffDate))
            .map((p) => ChartDataPoint(p.date, p.weight))
            .toList();
      case 'reps':
        // Total reps data from VolumePoint data
        return _selectedExercise!.volumeData
            .where((v) => v.date.isAfter(cutoffDate))
            .map((v) => ChartDataPoint(v.date, v.totalReps.toDouble()))
            .toList();
      default:
        return [];
    }
  }

  String _getCurrentValue(List<ChartDataPoint> data) {
    return data.isNotEmpty ? data.last.value.toInt().toString() : '0';
  }

  String _getAverageValue(List<ChartDataPoint> data) {
    if (data.isEmpty) return '0';
    final avg = data.map((d) => d.value).reduce((a, b) => a + b) / data.length;
    return avg.toInt().toString();
  }

  String _getMaxValue(List<ChartDataPoint> data) {
    if (data.isEmpty) return '0';
    final max = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    return max.toInt().toString();
  }

  String _getMinValue(List<ChartDataPoint> data) {
    if (data.isEmpty) return '0';
    final min = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    return min.toInt().toString();
  }

  String _getChangePercentage(List<ChartDataPoint> data) {
    if (data.length < 2) return '0';
    final first = data.first.value;
    final last = data.last.value;
    if (first == 0) return '0';
    final change = ((last - first) / first) * 100;
    return change > 0 ? '+${change.toInt()}' : '${change.toInt()}';
  }

  IconData _getTrendIcon(List<ChartDataPoint> data) {
    if (data.length < 2) return Icons.remove;

    final first = data.first.value;
    final last = data.last.value;
    if (first == 0) return Icons.remove;

    final change = ((last - first) / first) * 100;

    if (change > 5) {
      return Icons.trending_up; // Deutliche Steigerung
    } else if (change > 0) {
      return Icons.trending_up; // Leichte Steigerung
    } else if (change > -5) {
      return Icons.trending_flat; // Stagnation
    } else {
      return Icons.trending_down; // Rückgang
    }
  }

  Color _getChangeColor(List<ChartDataPoint> data) {
    if (data.length < 2) return Colors.grey;

    final first = data.first.value;
    final last = data.last.value;
    if (first == 0) return Colors.grey;

    final change = ((last - first) / first) * 100;

    if (change > 5) {
      return Colors.green; // Deutliche Steigerung
    } else if (change > 0) {
      return Colors.lightGreen; // Leichte Steigerung
    } else if (change > -5) {
      return Colors.orange; // Stagnation/Leichter Rückgang
    } else {
      return Colors.red; // Deutlicher Rückgang
    }
  }
}
