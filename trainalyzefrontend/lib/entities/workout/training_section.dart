// lib/models/training_section_dto.dart
import 'base_section.dart';
import 'exercise_section.dart';
import 'section_type.dart';

class TrainingSection extends BaseSection {
  List<ExerciseSection> exerciseSections;

  TrainingSection({
    int? id,
    required this.exerciseSections,
  }) : super(id: id, sectionType: SectionType.training);

  factory TrainingSection.fromJson(Map<String, dynamic> json) {
    return TrainingSection(
      id: json['id'] as int?,
      exerciseSections: (json['exerciseSections'] as List<dynamic>)
          .map((e) => ExerciseSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sectionType': sectionType.toJson(),
      'exerciseSections': exerciseSections.map((e) => e.toJson()).toList(),
    };
  }
}