import 'package:muscle_selector/muscle_selector.dart';

enum ExerciseType { KRAFT, CARDIO, MOBILITY }

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
          .map((muscle) => muscle.id.replaceAll(RegExp(r'\d+$'), '')) // Entferne Zahlen am Ende
          .toSet() // Entferne Duplikate
          .toList(), // Zurück zu List
      'equipment': equipment,
    };
  }

  // JSON-Deserialisierung (für zukünftige Verwendung)
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      type: ExerciseType.values.byName(json['type']),
      motionSymmetry: MotionSymmetry.values.byName(json['motionSymmetry']),
      muscleGroups: {}, //TODO: Man brauch kein Set<Muscles>, sondern List<String> der Muskelgruppen-Namen, weil man den Selector auch damt initalisieren kann
      equipment: json['equipment'],
    );
  }

  List<String> mapMuscleStringsToDataModel(List<String> muscleStrings){
    List<String> muscles = [];
    for (var muscleString in muscleStrings) {
      muscles.add("${muscleString}1");
      muscles.add("${muscleString}2");
    }
    return muscles;
  }
}

class ExerciseInputDTO {
  final int id; 
  final String name;
  final String type;
  final String motionSymmetry;
  final List<String> muscleGroups;
  final String equipment;

  ExerciseInputDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.motionSymmetry,
    required this.muscleGroups,
    required this.equipment,
  });

    factory ExerciseInputDTO.fromJson(Map<String, dynamic> json) {
    return ExerciseInputDTO(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      motionSymmetry: json['motionSymmetry'],
      muscleGroups: List<String>.from(json['muscleGroups']),
      equipment: json['equipment'],
    );
  }
}
