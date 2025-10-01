import 'package:flutter/material.dart';

enum ProgressTrend { improvement, stagnation, decline }

class ExerciseProgressData {
  final String exerciseId;
  final String exerciseName;
  final List<ProgressPoint> dataPoints;
  final List<VolumePoint> volumeData;
  final List<PersonalRecord> personalRecords;
  final ProgressTrend currentTrend;
  final double? oneRepMax;

  ExerciseProgressData({
    required this.exerciseId,
    required this.exerciseName,
    required this.dataPoints,
    required this.volumeData,
    required this.personalRecords,
    required this.currentTrend,
    this.oneRepMax,
  });

  Color get trendColor {
    switch (currentTrend) {
      case ProgressTrend.improvement:
        return Colors.green;
      case ProgressTrend.stagnation:
        return Colors.orange;
      case ProgressTrend.decline:
        return Colors.red;
    }
  }

  String get trendText {
    switch (currentTrend) {
      case ProgressTrend.improvement:
        return 'Fortschritt';
      case ProgressTrend.stagnation:
        return 'Stagnation';
      case ProgressTrend.decline:
        return 'Rückgang';
    }
  }
}

class ProgressPoint {
  final DateTime date;
  final double weight;
  final int reps;
  final double? estimatedOneRepMax;

  ProgressPoint({
    required this.date,
    required this.weight,
    required this.reps,
    this.estimatedOneRepMax,
  });
}

class VolumePoint {
  final DateTime date;
  final double totalVolume; // sets * reps * weight
  final int totalSets;
  final int totalReps;

  VolumePoint({
    required this.date,
    required this.totalVolume,
    required this.totalSets,
    required this.totalReps,
  });
}

class PersonalRecord {
  final DateTime date;
  final double weight;
  final int reps;
  final String type; // '1RM', 'Volume', 'Reps'
  final String description;

  PersonalRecord({
    required this.date,
    required this.weight,
    required this.reps,
    required this.type,
    required this.description,
  });
}

class TrainingHeatmapData {
  final DateTime date;
  final int intensity; // 0 = no training, 1 = training
  final Duration? duration;
  final int? exerciseCount;

  TrainingHeatmapData({
    required this.date,
    required this.intensity,
    this.duration,
    this.exerciseCount,
  });

  // Color property not needed anymore - handled in widget
}

class QuickStatCard {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? trend;

  QuickStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
  });
}

// Dummy Data Provider
class StatisticsDataProvider {
  static List<ExerciseProgressData> getAllExercises() {
    return [
      ExerciseProgressData(
        exerciseId: 'bench_press',
        exerciseName: 'Bankdrücken',
        currentTrend: ProgressTrend.improvement,
        oneRepMax: 85.0,
        dataPoints: _generateProgressData('bench_press', 60, 85),
        volumeData: _generateVolumeData('bench_press'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'squat',
        exerciseName: 'Kniebeugen',
        currentTrend: ProgressTrend.improvement,
        oneRepMax: 110.0,
        dataPoints: _generateProgressData('squat', 80, 110),
        volumeData: _generateVolumeData('squat'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'deadlift',
        exerciseName: 'Kreuzheben',
        currentTrend: ProgressTrend.stagnation,
        oneRepMax: 120.0,
        dataPoints: _generateProgressData(
          'deadlift',
          90,
          120,
          isStagnant: true,
        ),
        volumeData: _generateVolumeData('deadlift'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'overhead_press',
        exerciseName: 'Schulterdrücken',
        currentTrend: ProgressTrend.improvement,
        oneRepMax: 55.0,
        dataPoints: _generateProgressData('overhead_press', 40, 55),
        volumeData: _generateVolumeData('overhead_press'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'incline_press',
        exerciseName: 'Schrägbankdrücken',
        currentTrend: ProgressTrend.improvement,
        oneRepMax: 70.0,
        dataPoints: _generateProgressData('incline_press', 45, 70),
        volumeData: _generateVolumeData('incline_press'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'pull_ups',
        exerciseName: 'Klimmzüge',
        currentTrend: ProgressTrend.improvement,
        oneRepMax: 0.0, // Bodyweight
        dataPoints: _generateProgressData(
          'pull_ups',
          0,
          10,
        ), // Reps progression
        volumeData: _generateVolumeData('pull_ups'),
        personalRecords: [],
      ),
      ExerciseProgressData(
        exerciseId: 'rows',
        exerciseName: 'Rudern',
        currentTrend: ProgressTrend.stagnation,
        oneRepMax: 80.0,
        dataPoints: _generateProgressData('rows', 60, 80, isStagnant: true),
        volumeData: _generateVolumeData('rows'),
        personalRecords: [],
      ),
    ];
  }

  static List<ExerciseProgressData> getTopExercises() {
    return getAllExercises().take(4).toList();
  }

  static List<TrainingHeatmapData> getTrainingHeatmap() {
    List<TrainingHeatmapData> heatmapData = [];
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, 1, 1); // Start of year

    for (int i = 0; i < 365; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      int intensity = 0;

      // Simulate training pattern (3-4x per week)
      if (currentDate.weekday == 1 ||
          currentDate.weekday == 3 ||
          currentDate.weekday == 5) {
        // Occasional missed sessions
        if (i % 10 != 0) {
          intensity = 1; // Binary: training happened
        }
      }

      // Weekend training
      if (currentDate.weekday == 6 && i % 14 < 7) {
        intensity = 1; // Binary: training happened
      }

      heatmapData.add(
        TrainingHeatmapData(
          date: currentDate,
          intensity: intensity,
          duration: intensity > 0
              ? Duration(minutes: 60 + (i % 30)) // Random duration 60-90 min
              : null,
          exerciseCount: intensity > 0 ? 4 + (i % 3) : null, // 4-6 exercises
        ),
      );
    }

    return heatmapData;
  }

  static List<QuickStatCard> getQuickStats() {
    return [
      QuickStatCard(
        title: 'Diese Woche',
        value: '3',
        subtitle: 'Trainings absolviert',
        icon: Icons.fitness_center,
        color: Colors.green,
        trend: '+1 zur letzten Woche',
      ),
      QuickStatCard(
        title: 'Ø Trainingszeit',
        value: '67 min',
        subtitle: 'letzte 30 Tage',
        icon: Icons.timer,
        color: Colors.blue,
        trend: '+5 min',
      ),
    ];
  }

  static List<ProgressPoint> _generateProgressData(
    String exerciseId,
    double startWeight,
    double endWeight, {
    bool isStagnant = false,
  }) {
    List<ProgressPoint> points = [];
    DateTime now = DateTime.now();

    for (int i = 12; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i * 7)); // Weekly data points
      double weight;

      if (isStagnant && i < 6) {
        // Simulate stagnation in last 6 weeks
        weight = endWeight - 5;
      } else {
        // Progressive increase
        double progress = (12 - i) / 12;
        weight = startWeight + (endWeight - startWeight) * progress;
      }

      int reps =
          8 -
          (weight > startWeight + 15 ? 2 : 0); // Fewer reps at higher weights

      points.add(
        ProgressPoint(
          date: date,
          weight: weight,
          reps: reps,
          estimatedOneRepMax: weight * (1 + reps / 30),
        ),
      );
    }

    return points;
  }

  static List<VolumePoint> _generateVolumeData(String exerciseId) {
    List<VolumePoint> points = [];
    DateTime now = DateTime.now();

    for (int i = 12; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i * 7));

      int sets = 3 + (i % 2); // 3-4 sets
      int repsPerSet = 8 + (i % 3); // 8-10 reps
      double weightPerSet = 50 + i * 2; // Progressive weight

      points.add(
        VolumePoint(
          date: date,
          totalVolume: sets * repsPerSet * weightPerSet,
          totalSets: sets,
          totalReps: sets * repsPerSet,
        ),
      );
    }

    return points;
  }
}
