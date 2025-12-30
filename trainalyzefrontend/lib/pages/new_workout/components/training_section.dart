import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/workout/exercise_section.dart';
import 'package:trainalyzefrontend/entities/workout/pause_section.dart';
import 'package:trainalyzefrontend/entities/workout/training_section.dart' as model;
import 'package:trainalyzefrontend/entities/workout/section_type.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/exercise_card.dart';

class TrainingSection extends StatefulWidget {
  final model.TrainingSection section;
  final Function(model.TrainingSection) onUpdate;

  const TrainingSection({
    super.key,
    required this.section,
    required this.onUpdate,
  });

  @override
  State<TrainingSection> createState() => _TrainingSectionState();

}

class _TrainingSectionState extends State<TrainingSection> {
  late List<ExerciseSection> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.section.exerciseSections);
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        ExerciseSection(
          sectionType: SectionType.training,
          name: '',
          sets: 0,
          reps: 0,
          weight: 0.0,
          pauseSection: PauseSection(isDurationPause: false)
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

  void _updateExercise(int index, ExerciseSection exercise) {
    setState(() {
      _exercises[index] = exercise;
    });
    _updateSection();
  }

  void _updateSection() {
    final updatedSection = model.TrainingSection(
      id: widget.section.id,
      exerciseSections: List.from(_exercises),
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
