import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/dahsboard/components/info_card.dart';
import 'package:trainalyzefrontend/pages/dahsboard/components/chart_card.dart';
import 'package:trainalyzefrontend/pages/dahsboard/components/dummy_charts.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // Dummy-Daten
  static const String _currentWeight = '75.2';
  static const String _lastWorkout = 'Push Day A';
  static const String _lastWorkoutDate = 'vor 1 Tag';
  static const String _nextActivity = 'Pull Day B';
  static const String _currentPlan = 'Push/Pull/Legs';
  static const int _trainingsThisWeek = 3;
  static const int _minutesThisWeek = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 24),

              // Responsive Grid Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1200) {
                    // Desktop: 3 Spalten
                    return _buildDesktopLayout();
                  } else if (constraints.maxWidth > 800) {
                    // Tablet: 2 Spalten
                    return _buildTabletLayout();
                  } else {
                    // Mobile: 1 Spalte
                    return _buildMobileLayout();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.dashboard, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Heute ist ${_getCurrentDayName()}',
                  style: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Linke Spalte
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildLastTrainingCard(),
              const SizedBox(height: 16),
              _buildNextActivityCard(),
              const SizedBox(height: 16),
              _buildCurrentPlanCard(),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Mittlere Spalte
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildCurrentWeightCard(),
              const SizedBox(height: 16),
              _buildThisWeekCard(),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Rechte Spalte - Charts
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildWeightTrendChart(),
              const SizedBox(height: 16),
              _buildVolumeChart(),
              const SizedBox(height: 16),
              _buildFrequencyChart(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Erste Reihe: Info Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildLastTrainingCard(),
                  const SizedBox(height: 16),
                  _buildNextActivityCard(),
                  const SizedBox(height: 16),
                  _buildCurrentPlanCard(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _buildCurrentWeightCard(),
                  const SizedBox(height: 16),
                  _buildThisWeekCard(),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Charts in voller Breite
        _buildWeightTrendChart(),
        const SizedBox(height: 16),
        _buildVolumeChart(),
        const SizedBox(height: 16),
        _buildFrequencyChart(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildNextActivityCard(),
        const SizedBox(height: 16),
        _buildThisWeekCard(),
        const SizedBox(height: 16),
        _buildCurrentWeightCard(),
        const SizedBox(height: 16),
        _buildWeightTrendChart(),
        const SizedBox(height: 16),
        _buildLastTrainingCard(),
        const SizedBox(height: 16),
        _buildVolumeChart(),
        const SizedBox(height: 16),
        _buildCurrentPlanCard(),
        const SizedBox(height: 16),
        _buildFrequencyChart(),
      ],
    );
  }

  Widget _buildLastTrainingCard() {
    return InfoCard(
      title: 'Letztes Training',
      icon: Icons.fitness_center,
      accentColor: Colors.green,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _lastWorkout,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _lastWorkoutDate,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextActivityCard() {
    return InfoCard(
      title: 'Nächste Aktivität',
      icon: Icons.schedule,
      accentColor: Colors.orange,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nextActivity,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Montag',
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeightCard() {
    return InfoCard(
      title: 'Aktuelles Gewicht',
      icon: Icons.monitor_weight,
      accentColor: Colors.blue,
      content: Row(
        children: [
          Text(
            '$_currentWeight kg',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.trending_up, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    return InfoCard(
      title: 'Aktueller Trainingsplan',
      icon: Icons.calendar_today,
      accentColor: AppColors.primary,
      content: Text(
        _currentPlan,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThisWeekCard() {
    return InfoCard(
      title: 'Diese Woche',
      icon: Icons.bar_chart,
      accentColor: Colors.purple,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: AppColors.textPrimary.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '$_trainingsThisWeek Trainings',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.textPrimary.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '$_minutesThisWeek Minuten',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrendChart() {
    return ChartCard(
      title: 'Körpergewicht-Trend',
      chartBuilder: (timeRange) =>
          DummyLineChart(timeRange: timeRange, dataType: 'Körpergewicht'),
    );
  }

  Widget _buildVolumeChart() {
    return ChartCard(
      title: 'Trainingsvolumen',
      chartBuilder: (timeRange) =>
          DummyBarChart(timeRange: timeRange, dataType: 'Volumen'),
    );
  }

  Widget _buildFrequencyChart() {
    return ChartCard(
      title: 'Trainingsfrequenz',
      chartBuilder: (timeRange) =>
          DummyHeatmapChart(timeRange: timeRange, dataType: 'Frequenz'),
    );
  }

  String _getCurrentDayName() {
    final days = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ];
    final now = DateTime.now();
    return days[now.weekday - 1];
  }
}
