// lib/models/workout_dto.dart
import 'base_section.dart';

class WorkoutDTO {
  int? id;
  String name;
  List<BaseSection> sections;

  WorkoutDTO({
    this.id,
    required this.name,
    required this.sections,
  });

  factory WorkoutDTO.fromJson(Map<String, dynamic> json) {
    return WorkoutDTO(
      id: json['id'] as int?,
      name: json['name'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => BaseSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}