// lib/models/mobility_section_dto.dart
import 'base_section.dart';
import 'section_type.dart';

class MobilitySection extends BaseSection {
  double mobilityExerciseId;
  String name;
  int sets;
  int reps;
  
  MobilitySection({
    super.id,
    this.name = '',
    this.mobilityExerciseId = 0.0,
    this.sets = 0,
    this.reps = 0,
  }) : super(sectionType: SectionType.mobility);

  factory MobilitySection.fromJson(Map<String, dynamic> json) {
    return MobilitySection(
      id: json['id'] as int?,
      mobilityExerciseId: json['mobilityExerciseId'] as double? ?? 0.0,
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'mobilityExerciseId': mobilityExerciseId,
      'sets': sets,
      'reps': reps,
      'sectionType': sectionType.toJson(),
    };
  }
}