import 'package:intl/intl.dart';

class BodyWeight {
  final double weight;
  final DateTime date;

  BodyWeight({
    required this.weight,
    required this.date,
  });

  factory BodyWeight.fromJson(Map<String, dynamic> json) {
    return BodyWeight(
      weight: (json['bodyWeight'] as num).toDouble(),
      date: DateFormat('dd.MM.yyyy').parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,  // Geändert: "weight" → "bodyWeight" für Backend
      'date': DateFormat('dd.MM.yyyy').format(date),  // DateTime → String "dd.MM.yyyy"
    };
  }
}