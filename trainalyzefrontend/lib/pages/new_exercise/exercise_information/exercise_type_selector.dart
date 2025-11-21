import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';

class ExerciseTypeSelector extends StatefulWidget {
  final Function(ExerciseType?)? onTypeChanged; // Callback für Parent-Komponente
  
  const ExerciseTypeSelector({
    super.key,
    this.onTypeChanged,
  });

  @override
  State<ExerciseTypeSelector> createState() => _ExerciseTypeSelectorState();
}

class _ExerciseTypeSelectorState extends State<ExerciseTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return ExerciseTypeList(
      onTypeChanged: widget.onTypeChanged, // Callback weiterleiten
    );
  }
}

class ExerciseTypeList extends StatefulWidget {
  final Function(ExerciseType?)? onTypeChanged;
  
  const ExerciseTypeList({
    super.key,
    this.onTypeChanged,
  });

  @override
  State<ExerciseTypeList> createState() => _ExerciseTypeListState();
}

class _ExerciseTypeListState extends State<ExerciseTypeList> {
  ExerciseType? _selectedType = ExerciseType.KRAFT;

  // Getter für den aktuell ausgewählten Typ
  ExerciseType? get selectedExerciseType => _selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RadioGroup<ExerciseType>(
            groupValue: _selectedType,
            onChanged: (ExerciseType? value) {
              setState(() {
                _selectedType = value;
              });
              // Callback an Parent-Komponente
              if (widget.onTypeChanged != null) {
                widget.onTypeChanged!(value);
              }
            },
            child: Column(
              children: <Widget>[
                RadioListTile<ExerciseType>(
                  value: ExerciseType.KRAFT,
                  title: Text('Kraft'),
                  fillColor: WidgetStateProperty.all(AppColors.primary),
                ),
                RadioListTile<ExerciseType>(
                  value: ExerciseType.CARDIO,
                  title: Text('Cardio'),
                  fillColor: WidgetStateProperty.all(AppColors.primary),
                ),
                RadioListTile<ExerciseType>(
                  value: ExerciseType.MOBILITY,
                  title: Text('Mobility'),
                  fillColor: WidgetStateProperty.all(AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
