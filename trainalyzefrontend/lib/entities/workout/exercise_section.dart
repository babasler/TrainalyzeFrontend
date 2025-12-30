// lib/models/exercise_section_dto.dart
import 'package:trainalyzefrontend/entities/workout/base_section.dart';
import 'package:trainalyzefrontend/entities/workout/section_type.dart';

import 'pause_section.dart';

class ExerciseSection extends BaseSection {
  String name;
  int sets;
  int reps;
  double weight;
  int? exerciseId;
  PauseSection pauseSection;

  ExerciseSection({
    super.id,
    required super.sectionType,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.exerciseId,
    required this.pauseSection,
  });

  factory ExerciseSection.fromJson(Map<String, dynamic> json) {
    return ExerciseSection(
      id: json['id'] as int?,
      sectionType: SectionType.training,
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      exerciseId: json['exerciseId'] as int,
      pauseSection: PauseSection.fromJson(json['pauseSection'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'exerciseId': exerciseId,
      if (pauseSection != null) 'pauseSection': pauseSection!.toJson(),
    };
  }
}