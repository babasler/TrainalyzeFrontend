// Datenmodell für Trainingsplan-Erstellung

class TrainingPlanModel {
  String name;
  Map<int, String> selectedWorkouts;

  TrainingPlanModel({required this.name, Map<int, String>? selectedWorkouts})
    : selectedWorkouts =
          selectedWorkouts ??
          {
            1: '', // Montag
            2: '', // Dienstag
            3: '', // Mittwoch
            4: '', // Donnerstag
            5: '', // Freitag
            6: '', // Samstag
            7: '', // Sonntag
          };

  Map<String, dynamic> toJson() {
    return {'name': name, 'selectedWorkouts': selectedWorkouts};
  }

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) {
    return TrainingPlanModel(
      name: json['name'] ?? '',
      selectedWorkouts: Map<int, String>.from(json['selectedWorkouts'] ?? {}),
    );
  }

  // Helper-Methoden für UI
  static List<String> get weekDays => [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
    'Sonntag',
  ];

  static String getWeekDayName(int dayNumber) {
    if (dayNumber < 1 || dayNumber > 7) return '';
    return weekDays[dayNumber - 1];
  }
}
