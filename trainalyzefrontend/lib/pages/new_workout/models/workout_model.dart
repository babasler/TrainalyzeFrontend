// Datenmodelle für Workout-Erstellung

enum SectionType { warmUp, training, mobility }

class WorkoutModel {
  String trainingName;
  List<WorkoutSection> sections;

  WorkoutModel({required this.trainingName, required this.sections});

  Map<String, dynamic> toJson() {
    return {
      'trainingName': trainingName,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      trainingName: json['trainingName'] ?? '',
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((section) => WorkoutSection.fromJson(section))
              .toList() ??
          [],
    );
  }
}

class WorkoutSection {
  SectionType type;
  String? duration; // Nur für WarmUp
  bool? isDurationWarmUp; // Nur für WarmUp
  List<WorkoutExercise>? exercises; // Nur für Training und Mobility

  WorkoutSection({
    required this.type,
    this.duration,
    this.isDurationWarmUp,
    this.exercises,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': _sectionTypeToString(type)};

    if (type == SectionType.warmUp) {
      json['duration'] = duration ?? '';
      json['isDurantionWarmUp'] = isDurationWarmUp ?? false;
    } else if (type == SectionType.training || type == SectionType.mobility) {
      json['exercises'] = exercises?.map((ex) => ex.toJson()).toList() ?? [];
    }

    return json;
  }

  factory WorkoutSection.fromJson(Map<String, dynamic> json) {
    SectionType type = _stringToSectionType(json['type']);

    return WorkoutSection(
      type: type,
      duration: json['duration'],
      isDurationWarmUp: json['isDurantionWarmUp'],
      exercises: json['exercises'] != null
          ? (json['exercises'] as List<dynamic>)
                .map((ex) => WorkoutExercise.fromJson(ex))
                .toList()
          : null,
    );
  }

  static String _sectionTypeToString(SectionType type) {
    switch (type) {
      case SectionType.warmUp:
        return 'Warm Up';
      case SectionType.training:
        return 'Training';
      case SectionType.mobility:
        return 'Mobility';
    }
  }

  static SectionType _stringToSectionType(String type) {
    switch (type) {
      case 'Warm Up':
        return SectionType.warmUp;
      case 'Training':
        return SectionType.training;
      case 'Mobility':
        return SectionType.mobility;
      default:
        return SectionType.training;
    }
  }
}

class WorkoutExercise {
  String name;
  int sets;
  int repsPerSet;
  double? weight; // Nur für Training
  PauseModel? pauseAfterSets; // Nur für Training

  WorkoutExercise({
    required this.name,
    required this.sets,
    required this.repsPerSet,
    this.weight,
    this.pauseAfterSets,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
      'sets': sets,
      'repsPerSet': repsPerSet,
    };

    if (weight != null) {
      json['weight'] = weight;
    }

    if (pauseAfterSets != null) {
      json['pauseAfterSets'] = pauseAfterSets!.toJson();
    }

    return json;
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      name: json['name'] ?? '',
      sets: json['sets'] ?? 0,
      repsPerSet: json['repsPerSet'] ?? 0,
      weight: json['weight']?.toDouble(),
      pauseAfterSets: json['pauseAfterSets'] != null
          ? PauseModel.fromJson(json['pauseAfterSets'])
          : null,
    );
  }
}

class PauseModel {
  String type;
  String duration;
  bool isDurationPause;

  PauseModel({
    this.type = 'Pause',
    required this.duration,
    required this.isDurationPause,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration,
      'isDurationPause': isDurationPause,
    };
  }

  factory PauseModel.fromJson(Map<String, dynamic> json) {
    return PauseModel(
      type: json['type'] ?? 'Pause',
      duration: json['duration'] ?? '',
      isDurationPause: json['isDurationPause'] ?? false,
    );
  }
}
