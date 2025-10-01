import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:trainalyzefrontend/pages/new_exercise/used_muscles/muscle_selector.dart';

class SelectorChart extends StatefulWidget {
  final Function(Set<Muscle>)? onEquipmentChanged;

  const SelectorChart({
    super.key,
    this.onEquipmentChanged,
  });

  @override
  State<SelectorChart> createState() => _SelectorChartState();
}

class _SelectorChartState extends State<SelectorChart> {
  Set<Muscle>? selectedMuscles;

  // Define initial selected muscles (replace with actual Muscle instances as needed)
  final Set<Muscle> initialMuscles = {};

  @override
  Widget build(BuildContext context) {
    return MuscleSelector(
      initialSelectedMuscles: initialMuscles,
      onMusclesChanged: (muscles) {
        // Verarbeite die ausgewählten Muskeln
        setState(() {
          selectedMuscles = muscles;
          if (widget.onEquipmentChanged != null && muscles != null) {
            widget.onEquipmentChanged!(muscles);
          }

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
}