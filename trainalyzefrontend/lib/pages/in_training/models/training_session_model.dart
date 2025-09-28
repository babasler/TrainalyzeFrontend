class TrainingSessionModel {
  final String workoutName;
  final List<TrainingSessionItem> items; // Kann Übungen oder Pausen enthalten
  final DateTime startTime;
  DateTime? endTime;

  TrainingSessionModel({
    required this.workoutName,
    required this.items,
    required this.startTime,
    this.endTime,
  });

  // Berechne die aktuelle Gesamtdauer
  Duration getCurrentDuration() {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return DateTime.now().difference(startTime);
  }

  // Aktueller Item-Index
  int get currentItemIndex {
    for (int i = 0; i < items.length; i++) {
      if (!items[i].isCompleted) {
        return i;
      }
    }
    return items.length - 1; // Alle Items abgeschlossen
  }

  // Ist das Training abgeschlossen?
  bool get isCompleted {
    return items.every((item) => item.isCompleted);
  }

  // Nur Übungen (keine Pausen)
  List<TrainingExerciseSession> get exercises {
    return items.whereType<TrainingExerciseSession>().toList();
  }

  // Anzahl abgeschlossener Sätze gesamt
  int get completedSetsCount {
    return exercises.fold(
      0,
      (total, exercise) => total + exercise.completedSetsCount,
    );
  }

  // Gesamtanzahl Sätze
  int get totalSetsCount {
    return exercises.fold(0, (total, exercise) => total + exercise.sets.length);
  }

  // Progress basierend auf Items
  double get progress {
    if (items.isEmpty) return 0.0;
    int completed = items.where((item) => item.isCompleted).length;
    return completed / items.length;
  }
}

// Base class für alle Session Items
abstract class TrainingSessionItem {
  bool isCompleted;
  DateTime? startTime;
  DateTime? endTime;

  TrainingSessionItem({this.isCompleted = false, this.startTime, this.endTime});

  void complete() {
    isCompleted = true;
    endTime = DateTime.now();
  }
}

// Warm-Up Session (zeitbasiert oder individuell)
class WarmUpSession extends TrainingSessionItem {
  final String exerciseId;
  final String exerciseName;
  final String? duration; // "5:00" oder null für individuell
  final bool isDurationBased; // true = Timer, false = individuell

  WarmUpSession({
    required this.exerciseId,
    required this.exerciseName,
    this.duration,
    this.isDurationBased = false,
    bool isCompleted = false,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(isCompleted: isCompleted, startTime: startTime, endTime: endTime);
}

// Pause Session
class PauseSession extends TrainingSessionItem {
  final String duration; // "1:30"
  final bool isDurationBased; // immer true für Pausen

  PauseSession({
    required this.duration,
    this.isDurationBased = true,
    bool isCompleted = false,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(isCompleted: isCompleted, startTime: startTime, endTime: endTime);
}

class TrainingExerciseSession extends TrainingSessionItem {
  final String exerciseId;
  final String exerciseName;
  final String section; // "training", "mobility"
  final List<TrainingSetSession> sets;
  final PauseConfiguration pauseConfig;
  final ExerciseHistoryData? lastWorkoutData;

  TrainingExerciseSession({
    required this.exerciseId,
    required this.exerciseName,
    required this.section,
    required this.sets,
    required this.pauseConfig,
    this.lastWorkoutData,
    bool isCompleted = false,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(isCompleted: isCompleted, startTime: startTime, endTime: endTime);

  // Ist diese Übung abgeschlossen?
  @override
  bool get isCompleted {
    return sets.every((set) => set.isCompleted);
  }

  // Anzahl abgeschlossener Sätze
  int get completedSetsCount {
    return sets.where((set) => set.isCompleted).length;
  }

  // Aktueller Satz-Index
  int get currentSetIndex {
    for (int i = 0; i < sets.length; i++) {
      if (!sets[i].isCompleted) {
        return i;
      }
    }
    return sets.length - 1; // Alle Sätze abgeschlossen
  }

  @override
  void complete() {
    // Alle Sätze als abgeschlossen markieren
    for (var set in sets) {
      if (!set.isCompleted) {
        set.isCompleted = true;
        set.endTime = DateTime.now();
      }
    }
    super.complete();
  }
}

class TrainingSetSession {
  final double targetWeight;
  final int targetReps;
  double? actualWeight;
  int? actualReps;
  DateTime? startTime;
  DateTime? endTime;
  bool isCompleted;

  TrainingSetSession({
    required this.targetWeight,
    required this.targetReps,
    this.actualWeight,
    this.actualReps,
    this.startTime,
    this.endTime,
    this.isCompleted = false,
  });

  // Satz als abgeschlossen markieren
  void complete(double weight, int reps) {
    actualWeight = weight;
    actualReps = reps;
    endTime = DateTime.now();
    isCompleted = true;
  }
}

class PauseConfiguration {
  final PauseType type;
  final Duration? fixedDuration; // null bei individueller Pause

  PauseConfiguration({required this.type, this.fixedDuration});
}

enum PauseType {
  fixed, // Countdown-Timer mit fester Zeit - NICHT überspringbar
  individual, // Stopuhr, Benutzer entscheidet
}

class ExerciseHistoryData {
  final DateTime lastWorkoutDate;
  final List<HistorySet> sets;

  ExerciseHistoryData({required this.lastWorkoutDate, required this.sets});
}

class HistorySet {
  final double weight;
  final int reps;

  HistorySet({required this.weight, required this.reps});
}
