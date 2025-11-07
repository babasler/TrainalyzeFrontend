class Profile {
  String weightIncreaseType;
  double increaseWeight;
  int increaseAtReps;
  String workoutSelection;
  String selectedTrainingsplan;
  String handleMissingWorkout;
  double bodyWeight;
  double bodyHeight;
  double bmi;

  Profile({
    required this.weightIncreaseType,
    required this.increaseWeight,
    required this.increaseAtReps,
    required this.workoutSelection,
    required this.selectedTrainingsplan,
    required this.handleMissingWorkout,
    required this.bodyWeight,
    required this.bodyHeight,
    required this.bmi,
  });

  // JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'weightIncreaseType': weightIncreaseType,
      'increaseWeight': increaseWeight,
      'increaseAtReps': increaseAtReps,
      'workoutSelection': workoutSelection,
      'selectedTrainingsplan': selectedTrainingsplan,
      'handleMissingWorkout': handleMissingWorkout,
      'bodyWeight': bodyWeight,
      'bodyHeight': bodyHeight,
      'bmi': bmi,
    };
  }

  // JSON-Deserialisierung (für zukünftige Verwendung)
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      weightIncreaseType: json['weightIncreaseType'],
      increaseWeight: json['increaseWeight'],
      increaseAtReps: json['increaseAtReps'],
      workoutSelection: json['workoutSelection'],
      selectedTrainingsplan: json['selectedTrainingsplan'],
      handleMissingWorkout: json['handleMissingWorkout'],
      bodyWeight: json['bodyWeight'],
      bodyHeight: json['bodyHeight'],
      bmi: json['bmi'],
    );
  }
}

class ProfileOutputDTO {
  
}
