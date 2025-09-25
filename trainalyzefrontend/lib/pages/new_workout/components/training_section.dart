import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/models/workout_model.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/exercise_card.dart';

class TrainingSection extends StatefulWidget {
  final WorkoutSection section;
  final Function(WorkoutSection) onUpdate;

  const TrainingSection({
    super.key,
    required this.section,
    required this.onUpdate,
  });

  @override
  State<TrainingSection> createState() => _TrainingSectionState();
}

class _TrainingSectionState extends State<TrainingSection> {
  late List<WorkoutExercise> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.section.exercises ?? []);
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        WorkoutExercise(
          name: '',
          sets: 3,
          repsPerSet: 12,
          weight: 20.0,
          pauseAfterSets: PauseModel(duration: '60', isDurationPause: true),
        ),
      );
    });
    _updateSection();
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
    _updateSection();
  }

  void _updateExercise(int index, WorkoutExercise exercise) {
    setState(() {
      _exercises[index] = exercise;
    });
    _updateSection();
  }

  void _updateSection() {
    final updatedSection = WorkoutSection(
      type: SectionType.training,
      exercises: List.from(_exercises),
    );
    widget.onUpdate(updatedSection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exercises List
        if (_exercises.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keine Übungen hinzugefügt',
                    style: TextStyle(
                      color: AppColors.textPrimary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(
            _exercises.length,
            (index) => ExerciseCard(
              key: ValueKey('training_exercise_$index'),
              exercise: _exercises[index],
              isTraining: true,
              onUpdate: (exercise) => _updateExercise(index, exercise),
              onRemove: () => _removeExercise(index),
            ),
          ),

        const SizedBox(height: 16),

        // Add Exercise Button (moved to bottom)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addExercise,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.add, size: 18),
            label: Text('Übung hinzufügen'),
          ),
        ),
      ],
    );
  }
}
