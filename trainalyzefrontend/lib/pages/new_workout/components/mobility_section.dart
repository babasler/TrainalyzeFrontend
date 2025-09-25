import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/models/workout_model.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/exercise_card.dart';

class MobilitySection extends StatefulWidget {
  final WorkoutSection section;
  final Function(WorkoutSection) onUpdate;

  const MobilitySection({
    super.key,
    required this.section,
    required this.onUpdate,
  });

  @override
  State<MobilitySection> createState() => _MobilitySectionState();
}

class _MobilitySectionState extends State<MobilitySection> {
  late List<WorkoutExercise> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.section.exercises ?? []);
  }

  void _addExercise() {
    setState(() {
      _exercises.add(WorkoutExercise(name: '', sets: 2, repsPerSet: 10));
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
      type: SectionType.mobility,
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
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.self_improvement,
                    size: 48,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keine Mobility-Übungen hinzugefügt',
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
              key: ValueKey('mobility_exercise_$index'),
              exercise: _exercises[index],
              isTraining: false,
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
              backgroundColor: Colors.green.withOpacity(0.1),
              foregroundColor: Colors.green,
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.add, size: 18),
            label: Text('Mobility Übung hinzufügen'),
          ),
        ),
      ],
    );
  }
}
