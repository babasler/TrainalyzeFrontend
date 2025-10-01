import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/exercise_name.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/exercise_type_selector.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/muscle_symmetry.dart';

class InformationChart extends StatefulWidget {
  final Function(String)? onExerciseNameChanged;
  final Function(ExerciseType?)? onExerciseTypeChanged;
  final Function(MotionSymmetry?)? onMotionSymmetryChanged;

  const InformationChart({
    super.key,
    this.onExerciseNameChanged,
    this.onExerciseTypeChanged,
    this.onMotionSymmetryChanged,
  });

  @override
  State<InformationChart> createState() => _InformationChartState();
}

class _InformationChartState extends State<InformationChart> {
  String _exerciseName = ''; // String statt TextEditingController
  ExerciseType? _selectedType;
  MotionSymmetry? _selectedSymmetry; // Hinzugefügt für MuscleSymmetry

  @override
  void dispose() {
    // TextEditingController entfernt
    super.dispose();
  }

  // Getters für die Werte
  String get exerciseName => _exerciseName;
  ExerciseType? get selectedExerciseType => _selectedType;
  MotionSymmetry? get selectedMuscleSymmetry =>
      _selectedSymmetry; // Hinzugefügt

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
            height: containerHeight, // Feste Höhe wie die anderen Charts
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Überschrift (fixiert)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'Übungsinformationen',
                    style: TextStyle(
                      fontSize: containerWidth * 0.06,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: 'SF Pro Display',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Scrollbarer Formular-Bereich
                Expanded(
                  // Zurück zu Expanded für verfügbaren Platz innerhalb der festen Höhe
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        ExerciseName(
                          onNameChanged: (String name) {
                            setState(() {
                              _exerciseName = name;
                            });
                            // Callback an Parent-Komponente
                            if (widget.onExerciseNameChanged != null) {
                              widget.onExerciseNameChanged!(name);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        ExerciseTypeSelector(
                          onTypeChanged: (ExerciseType? type) {
                            setState(() {
                              _selectedType = type;
                            });
                            // Callback an Parent-Komponente
                            if (widget.onExerciseTypeChanged != null) {
                              widget.onExerciseTypeChanged!(type);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        MuscleSymmetrySelector(
                          onSymmetryChanged: (MotionSymmetry? symmetry) {
                            setState(() {
                              _selectedSymmetry = symmetry;
                            });
                            // Callback an Parent-Komponente
                            if (widget.onMotionSymmetryChanged != null) {
                              widget.onMotionSymmetryChanged!(symmetry);
                            }
                          },
                        ),
                        const SizedBox(height: 16), // Extra Platz am Ende
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
