import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:trainalyzefrontend/pages/new_exercise/used_muscles/muscle_selector.dart';

class SelectorChart extends StatefulWidget {
  const SelectorChart({super.key});

  @override
  State<SelectorChart> createState() => _SelectorChartState();
}

class _SelectorChartState extends State<SelectorChart> {
  Set<Muscle>? selectedMuscles;

  // Define initial selected muscles (replace with actual Muscle instances as needed)
  final Set<Muscle> myInitialMuscles = {};

  @override
  Widget build(BuildContext context) {
    return MuscleSelector(
      initialSelectedMuscles: myInitialMuscles,
      onMusclesChanged: (muscles) {
        // Verarbeite die ausgewählten Muskeln
        setState(() {
          selectedMuscles = muscles;
        });
      },
    );
  }
}

class ExerciseForm extends StatefulWidget {
  const ExerciseForm({super.key});

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  Set<Muscle>? selectedMuscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MuscleSelector(
          onMusclesChanged: (muscles) {
            setState(() {
              selectedMuscles = muscles;
            });
          },
        ),
      ],
    );
  }

  void _saveExercise() {
    if (selectedMuscles != null) {
      print('Speichere Übung mit Muskeln: $selectedMuscles');
    }
  }
}