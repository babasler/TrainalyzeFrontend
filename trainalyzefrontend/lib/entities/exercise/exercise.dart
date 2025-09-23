enum ExerciseType { kraft, cardio, mobility, unilateral }
enum MuscleSymmetry { unilateral, bilateral }

class Exercise {
  final String name;
  final ExerciseType type;

  Exercise({
    required this.name,
    required this.type,
  });
}