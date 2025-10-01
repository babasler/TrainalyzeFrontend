import 'package:json_annotation/json_annotation.dart';
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
}
