import 'package:flutter/material.dart';
import '../../enviroment/env.dart';
import 'models/statistics_models.dart';
import 'widgets/statistics_widgets.dart';
import 'exercise_detail_page.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<ExerciseProgressData> _exercises = [];
  List<TrainingHeatmapData> _heatmapData = [];
  List<QuickStatCard> _quickStats = [];
  bool _isLoading = true;
  String _selectedTimeRange = '30 Tage';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _exercises = StatisticsDataProvider.getTopExercises();
      _heatmapData = StatisticsDataProvider.getTrainingHeatmap();
      _quickStats = StatisticsDataProvider.getQuickStats();
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
          'Statistiken',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedTimeRange = value);
              _loadData();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7 Tage', child: Text('7 Tage')),
              const PopupMenuItem(value: '30 Tage', child: Text('30 Tage')),
              const PopupMenuItem(value: '3 Monate', child: Text('3 Monate')),
              const PopupMenuItem(value: '1 Jahr', child: Text('1 Jahr')),
            ],
          ),
        ],
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
            'Lade Statistiken...',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time range indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.surface,
              child: Row(
                children: [
                  Icon(Icons.date_range, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Zeitraum: $_selectedTimeRange',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Training Heatmap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TrainingHeatmapWidget(
                data: _heatmapData,
                onDayTapped: (date) {
                  _showDayDetails(date);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dashboard, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Übersicht',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: _quickStats.length,
                    itemBuilder: (context, index) {
                      return QuickStatCardWidget(stat: _quickStats[index]);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Top Exercises
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Hauptübungen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ExerciseDetailPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Alle anzeigen',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: _exercises.take(4).length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return MiniProgressChart(
                        data: exercise.dataPoints,
                        exerciseName: exercise.exerciseName,
                        trend: exercise.currentTrend,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ExerciseDetailPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showDayDetails(DateTime date) {
    final dayData = _heatmapData.firstWhere(
      (d) => d.date.day == date.day && d.date.month == date.month,
      orElse: () => TrainingHeatmapData(date: date, intensity: 0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '${date.day}.${date.month}.${date.year}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dayData.intensity > 0) ...[
              const Text(
                '✅ Training absolviert',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (dayData.duration != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Dauer: ${dayData.duration!.inMinutes} Minuten',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
              if (dayData.exerciseCount != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Übungen: ${dayData.exerciseCount}',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ] else ...[
              Text(
                'Kein Training an diesem Tag',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
