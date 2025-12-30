import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/workout/section_type.dart';
import 'package:trainalyzefrontend/entities/workout/workout.dart';
import 'package:trainalyzefrontend/entities/workout/base_section.dart';
import 'package:trainalyzefrontend/entities/workout/warmup_section.dart';
import 'package:trainalyzefrontend/entities/workout/training_section.dart' as model;
import 'package:trainalyzefrontend/entities/workout/exercise_section.dart';
import 'package:trainalyzefrontend/entities/workout/mobility_section.dart';
import 'package:trainalyzefrontend/entities/workout/pause_section.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/section_card.dart';
import 'package:trainalyzefrontend/services/workout/workout_service.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({super.key, this.workoutService});

  final WorkoutService? workoutService;

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final _formKey = GlobalKey<FormState>();
  final _trainingNameController = TextEditingController();

  late Workout _workout;
  late WorkoutService _workoutService;

  @override
  void initState() {
    super.initState();
    _workout = Workout(name: '', sections: []);
    _workoutService = widget.workoutService ?? WorkoutService();
  }

  @override
  void dispose() {
    _trainingNameController.dispose();
    super.dispose();
  }

  void _addSection(SectionType type) {
    setState(() {
      BaseSection newSection;
      switch (type) {
        case SectionType.warmup:
          newSection = WarmUpSection(
            duration: "10:00", // 10 Minuten als Startwert
            isDurationWarmUp: true,
          );
          break;
        case SectionType.training:
          newSection = model.TrainingSection(
            exerciseSections: <ExerciseSection>[],
          );
          break;
        case SectionType.mobility:
          newSection = MobilitySection(
            name: '',
            sets: 0,
            reps: 0,
          );
          break;
        case SectionType.pause:
          newSection = PauseSection(
            duration: "00:00",
            isDurationPause: true,
          );
          break;
      }
      _workout.sections.add(newSection);
    });
  }

  void _removeSection(int index) {
    setState(() {
      _workout.sections.removeAt(index);
    });
  }

  void _updateSection(int index, BaseSection section) {
    setState(() {
      _workout.sections[index] = section;
    });
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState?.validate() ?? false) {
      _workout.name = _trainingNameController.text;

      // JSON generieren
      final json = _workout.toJson();
      print('💾 Workout JSON:');
      print(json);

      _workoutService.createWorkout(_workout);

      // TODO: Backend-Integration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout "${_workout.name}" gespeichert!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header mit Workout-Name
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Neues Workout erstellen',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _trainingNameController,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Workout Name',
                        labelStyle: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte einen Workout-Namen eingeben';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Add Section Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _addSection(SectionType.warmup),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.whatshot, size: 18),
                        label: Text('Warm Up'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _addSection(SectionType.training),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.fitness_center, size: 18),
                        label: Text('Training'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _addSection(SectionType.mobility),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.self_improvement, size: 18),
                        label: Text('Mobility'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sections List
              Expanded(
                child: _workout.sections.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 64,
                              color: AppColors.textPrimary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Füge Sections hinzu\num dein Workout zu erstellen',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _workout.sections.length,
                        itemBuilder: (context, index) {
                          return SectionCard(
                            key: ValueKey('section_$index'),
                            section: _workout.sections[index],
                            onUpdate: (section) =>
                                _updateSection(index, section),
                            onRemove: () => _removeSection(index),
                          );
                        },
                      ),
              ),

              // Save Button
              Container(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Workout speichern',
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
        ),
      ),
    );
  }
}
