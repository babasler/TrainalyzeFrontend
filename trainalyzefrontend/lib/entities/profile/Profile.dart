class Profile {
  int profileId;  // Geändert von double zu int
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
    required this.profileId,
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
      'profileId': profileId,
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
      profileId: (json['profileId'] as num).toInt(),  // Geändert zu toInt()
      weightIncreaseType: json['weightIncreaseType'],
      increaseWeight: (json['increaseWeight'] as num).toDouble(),
      increaseAtReps: json['increaseAtReps'],
      workoutSelection: json['workoutSelection'],
      selectedTrainingsplan: json['selectedTrainingsplan'],
      handleMissingWorkout: json['handleMissingWorkout'],
      bodyWeight: (json['bodyWeight'] as num).toDouble(),
      bodyHeight: (json['bodyHeight'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
    );
  }
}

class ProfileOutputDTO {
  int profileId;  // Geändert von double zu int
  String weightIncreaseType;
  double increaseWeight;
  int increaseAtReps;
  String workoutSelection;
  String selectedTrainingsplan;
  String handleMissingWorkout;
  double bodyHeight;

  ProfileOutputDTO({
    required this.profileId,
    required this.weightIncreaseType,
    required this.increaseWeight,
    required this.increaseAtReps,
    required this.workoutSelection,
    required this.selectedTrainingsplan,
    required this.handleMissingWorkout,
    required this.bodyHeight,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'weightIncreaseType': weightIncreaseType,
      'increaseWeight': increaseWeight,
      'increaseAtReps': increaseAtReps,
      'workoutSelection': workoutSelection,
      'selectedTrainingsplan': selectedTrainingsplan,
      'handleMissingWorkout': handleMissingWorkout,
      'bodyHeight': bodyHeight,
    };
  }
}
