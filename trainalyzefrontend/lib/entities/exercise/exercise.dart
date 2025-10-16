import 'package:muscle_selector/muscle_selector.dart';

enum ExerciseType { kraft, cardio, mobility, unilateral }

enum MotionSymmetry { unilateral, bilateral }

class Exercise {
  final String name;
  final ExerciseType type;
  final MotionSymmetry motionSymmetry;
  Set<Muscle> muscleGroups;
  final String equipment;

  Exercise({
    required this.name,
    required this.type,
    required this.motionSymmetry,
    required this.muscleGroups,
    required this.equipment,
  });

  // JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name, // Enum als String
      'motionSymmetry': motionSymmetry.name, // Enum als String
      'muscleGroups': muscleGroups
          .map((muscle) => muscle.toString())
          .toList(), // Set<Muscle> als List<String>
      'equipment': equipment,
    };
  }

  // JSON-Deserialisierung (für zukünftige Verwendung)
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      type: ExerciseType.values.byName(json['type']),
      motionSymmetry: MotionSymmetry.values.byName(json['motionSymmetry']),
      muscleGroups: {}, //TODO: Temporär leer, da Muscle-Deserialisierung komplex ist
      equipment: json['equipment'],
    );
  }
}
