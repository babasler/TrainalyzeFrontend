import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_exercise/exercise_information/information_chart.dart';
import 'package:trainalyzefrontend/pages/new_exercise/required_equipment/equipment_chart.dart';
import 'package:trainalyzefrontend/pages/new_exercise/used_muscles/muscle_selector.dart';
import 'package:trainalyzefrontend/services/exercise/exercise_service.dart';

class NewExercise extends StatefulWidget {
  final ExerciseService? exerciseService;

  const NewExercise({super.key, this.exerciseService});

  @override
  State<NewExercise> createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  Exercise exercise = Exercise(
    name: '',
    type: ExerciseType.kraft,
    motionSymmetry: MotionSymmetry.bilateral,
    muscleGroups: {},
    equipment: '',
  );

  // Key für Force-Rebuild aller Child-Widgets bei Reset
  Key _formKey = UniqueKey();

  // Callback-Methoden für Updates
  void _onExerciseNameChanged(String name) {
    setState(() {
      exercise = Exercise(
        name: name,
        type: exercise.type,
        motionSymmetry: exercise.motionSymmetry,
        muscleGroups: exercise.muscleGroups,
        equipment: exercise.equipment,
      );
    });
  }

  void _onExerciseTypeChanged(ExerciseType? type) {
    if (type != null) {
      setState(() {
        exercise = Exercise(
          name: exercise.name,
          type: type,
          motionSymmetry: exercise.motionSymmetry,
          muscleGroups: exercise.muscleGroups,
          equipment: exercise.equipment,
        );
      });
    }
  }

  void _onMotionSymmetryChanged(MotionSymmetry? symmetry) {
    if (symmetry != null) {
      setState(() {
        exercise = Exercise(
          name: exercise.name,
          type: exercise.type,
          motionSymmetry: symmetry,
          muscleGroups: exercise.muscleGroups,
          equipment: exercise.equipment,
        );
      });
    }
  }

  void _onMusclesChanged(Set<Muscle>? muscles) {
    setState(() {
      exercise = Exercise(
        name: exercise.name,
        type: exercise.type,
        motionSymmetry: exercise.motionSymmetry,
        muscleGroups: muscles ?? {},
        equipment: exercise.equipment,
      );
    });
  }

  void _onEquipmentChanged(String equipment) {
    setState(() {
      exercise = Exercise(
        name: exercise.name,
        type: exercise.type,
        motionSymmetry: exercise.motionSymmetry,
        muscleGroups: exercise.muscleGroups,
        equipment: equipment,
      );
    });
  }

  /// Setzt das Exercise-Objekt und die UI zurück
  void _resetExercise() {
    setState(() {
      exercise = Exercise(
        name: '',
        type: ExerciseType.kraft,
        motionSymmetry: MotionSymmetry.bilateral,
        muscleGroups: {},
        equipment: '',
      );
      // Key ändern für Force-Rebuild aller Child-Widgets
      _formKey = UniqueKey();
    });
  }

  Future<void> _saveExercise() async {
    // Hier würde die Speichern-Logik implementiert werden
    //TODO: Hier sollte noch Logik zum checken rein, ob alles ausgefüllt ist.
    if (exercise.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte geben Sie einen Übungsnamen ein')),
      );
      return;
    }
    // Verwende ExerciseService falls verfügbar, ansonsten Fallback
    bool exerciseSavedSuccessfully = false;
    if (widget.exerciseService != null) {
      exerciseSavedSuccessfully = await widget.exerciseService!.saveExercise(
        exercise,
      );
    }

    if (!exerciseSavedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Speichern der Übung')),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Übung "${exercise.name}" erfolgreich gespeichert\n'),
          duration: const Duration(seconds: 3),
        ),
      );

      // Übung und UI zurücksetzen
      _resetExercise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Prüfe das Verhältnis: Hochformat vs Querformat
          final bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            // Querformat: Nebeneinander (Row) - mit flexibler Höhe
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flexible Row für Charts mit maximaler verfügbarer Höhe
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          constraints.maxHeight - 100, // Reserve für Button
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InformationChart(
                              key: _formKey, // Force rebuild on reset
                              onExerciseNameChanged: _onExerciseNameChanged,
                              onExerciseTypeChanged: _onExerciseTypeChanged,
                              onMotionSymmetryChanged: _onMotionSymmetryChanged,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: MuscleSelector(
                                key: ValueKey(
                                  'muscle_${_formKey.toString()}',
                                ), // Force rebuild
                                onMusclesChanged: _onMusclesChanged,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: EquipmentChart(
                              key: ValueKey(
                                'equipment_${_formKey.toString()}',
                              ), // Force rebuild
                              onEquipmentChanged: _onEquipmentChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Reduzierter Abstand
                  Center(
                    child: SizedBox(
                      width:
                          constraints.maxWidth *
                          0.6, // 60% der Bildschirmbreite
                      child: ElevatedButton(
                        onPressed: _saveExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Übung speichern',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Hochformat: Untereinander (Column)
            return SingleChildScrollView(
              child: Column(
                children: [
                  InformationChart(
                    key: _formKey, // Force rebuild on reset
                    onExerciseNameChanged: _onExerciseNameChanged,
                    onExerciseTypeChanged: _onExerciseTypeChanged,
                    onMotionSymmetryChanged: _onMotionSymmetryChanged,
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: MuscleSelector(
                      key: ValueKey(
                        'muscle_${_formKey.toString()}',
                      ), // Force rebuild
                      onMusclesChanged: _onMusclesChanged,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EquipmentChart(
                    key: ValueKey(
                      'equipment_${_formKey.toString()}',
                    ), // Force rebuild
                    onEquipmentChanged: _onEquipmentChanged,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Übung speichern',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
