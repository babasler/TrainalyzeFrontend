// lib/models/workout_dto.dart
import 'base_section.dart';

class Workout {
  int? id;
  String name;
  List<BaseSection> sections;

  Workout({
    this.id,
    required this.name,
    required this.sections,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
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