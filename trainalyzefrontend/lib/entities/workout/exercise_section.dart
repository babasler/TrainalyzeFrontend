// lib/models/exercise_section_dto.dart
import 'pause_section.dart';

class ExerciseSection {
  int? id;
  int sets;
  int repetitions;
  double weight;
  int exerciseId;
  PauseSection? pauseSection;

  ExerciseSection({
    this.id,
    required this.sets,
    required this.repetitions,
    required this.weight,
    required this.exerciseId,
    this.pauseSection,
  });

  factory ExerciseSection.fromJson(Map<String, dynamic> json) {
    return ExerciseSection(
      id: json['id'] as int?,
      sets: json['sets'] as int,
      repetitions: json['repetitions'] as int,
      weight: (json['weight'] as num).toDouble(),
      exerciseId: json['exerciseId'] as int,
      pauseSection: json['pauseSection'] != null
          ? PauseSection.fromJson(json['pauseSection'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sets': sets,
      'repetitions': repetitions,
      'weight': weight,
      'exerciseId': exerciseId,
      if (pauseSection != null) 'pauseSection': pauseSection!.toJson(),
    };
  }
}