import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/exercise_name.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/exercise_type_selector.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/muscle_symmetry.dart';

class InformationChart extends StatefulWidget {
  const InformationChart({super.key});

  @override
  State<InformationChart> createState() => _InformationChartState();
}

class _InformationChartState extends State<InformationChart> {
  String _exerciseName = ''; // String statt TextEditingController
  ExerciseType? _selectedType;
  MuscleSymmetry? _selectedSymmetry; // Hinzugefügt für MuscleSymmetry

  @override
  void dispose() {
    // TextEditingController entfernt
    super.dispose();
  }

  // Getters für die Werte
  String get exerciseName => _exerciseName;
  ExerciseType? get selectedExerciseType => _selectedType;
  MuscleSymmetry? get selectedMuscleSymmetry => _selectedSymmetry; // Hinzugefügt

  void saveExercise() {
    if (_exerciseName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte Übungsname eingeben')),
      );
      return;
    }

    // Exercise erstellen und speichern
    final exercise = Exercise(
      name: _exerciseName,
      type: _selectedType ?? ExerciseType.kraft,
    );

    print('Übung gespeichert: ${exercise.name}, Typ: ${exercise.type}');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive Größen basierend auf verfügbarem Platz
        final double containerWidth = constraints.maxWidth.clamp(
          200.0,
          AppDimensions.chartWidth,
        );
        final double containerHeight = constraints.maxHeight.clamp(
          300.0,
          AppDimensions.chartHeight,
        );

        return Center(
          child: Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusLarge, // Abgerundete Ecken
            ),
            child: Column(
              children: [
                // Überschrift
                Padding(
                  padding: EdgeInsets.only(
                    top: containerHeight * 0.04,
                    bottom: containerHeight * 0.03,
                  ),
                  child: Text(
                    'Übungsinformationen',
                    style: TextStyle(
                      fontSize: containerWidth * 0.06,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: 'SF Pro Display', // Neutrale Schriftart
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Formular-Bereich
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0)),
                        ExerciseName(
                          onNameChanged: (String name) {
                            setState(() {
                              _exerciseName = name;
                            });
                          },
                        ),
                        ExerciseTypeSelector(
                          onTypeChanged: (ExerciseType? type) {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                        ),
                        MuscleSymmetrySelector(
                          onSymmetryChanged: (MuscleSymmetry? symmetry) {
                            setState(() {
                              _selectedSymmetry = symmetry;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}