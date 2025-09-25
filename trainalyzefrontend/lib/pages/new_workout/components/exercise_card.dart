import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/models/workout_model.dart';

class ExerciseCard extends StatefulWidget {
  final WorkoutExercise exercise;
  final bool isTraining; // true = Training Section, false = Mobility Section
  final Function(WorkoutExercise) onUpdate;
  final VoidCallback onRemove;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.isTraining,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _pauseDurationController;
  late bool _isPauseDuration;
  late String _selectedExercise;

  // Dummy-Übungslisten
  final List<String> _trainingExercises = [
    'Bankdrücken',
    'Kniebeugen',
    'Kreuzheben',
    'Schulterdrücken',
    'Bizeps Curls',
    'Trizeps Dips',
    'Rudern',
    'Klimmzüge',
    'Ausfallschritte',
    'Dumbbell Press',
  ];

  final List<String> _mobilityExercises = [
    'Katze-Kuh Stretch',
    'Hip Flexor Stretch',
    'Schulter Rollen',
    'Nacken Stretch',
    'Wirbelsäulen Drehung',
    'Hamstring Stretch',
    'Calf Stretch',
    'Chest Stretch',
    'Quad Stretch',
    'Plank Hold',
  ];

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.exercise.name.isNotEmpty
        ? widget.exercise.name
        : (widget.isTraining
              ? _trainingExercises.first
              : _mobilityExercises.first);
    _setsController = TextEditingController(
      text: widget.exercise.sets.toString(),
    );
    _repsController = TextEditingController(
      text: widget.exercise.repsPerSet.toString(),
    );
    _weightController = TextEditingController(
      text: widget.exercise.weight?.toString() ?? '20.0',
    );
    _pauseDurationController = TextEditingController(
      text: widget.exercise.pauseAfterSets?.duration ?? '60',
    );
    _isPauseDuration = widget.exercise.pauseAfterSets?.isDurationPause ?? true;
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _pauseDurationController.dispose();
    super.dispose();
  }

  void _updateExercise() {
    final updatedExercise = WorkoutExercise(
      name: _selectedExercise,
      sets: int.tryParse(_setsController.text) ?? 0,
      repsPerSet: int.tryParse(_repsController.text) ?? 0,
      weight: widget.isTraining
          ? (double.tryParse(_weightController.text) ?? 0.0)
          : null,
      pauseAfterSets: widget.isTraining && _isPauseDuration
          ? PauseModel(
              duration: _pauseDurationController.text.isNotEmpty
                  ? _pauseDurationController.text
                  : '0',
              isDurationPause: _isPauseDuration,
            )
          : null,
    );
    widget.onUpdate(updatedExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: widget.isTraining
              ? AppColors.primary.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with delete button
            Row(
              children: [
                Icon(
                  widget.isTraining
                      ? Icons.fitness_center
                      : Icons.self_improvement,
                  color: widget.isTraining ? AppColors.primary : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isTraining ? 'Training Übung' : 'Mobility Übung',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.withOpacity(0.7),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Exercise Dropdown
            DropdownButtonFormField<String>(
              value: _selectedExercise,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Übung auswählen',
                labelStyle: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.isTraining ? AppColors.primary : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.isTraining ? AppColors.primary : Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              dropdownColor: AppColors.surface,
              items:
                  (widget.isTraining ? _trainingExercises : _mobilityExercises)
                      .map(
                        (exercise) => DropdownMenuItem<String>(
                          value: exercise,
                          child: Text(
                            exercise,
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedExercise = value;
                  });
                  _updateExercise();
                }
              },
            ),

            const SizedBox(height: 16),

            // Sets and Reps
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Sätze',
                      labelStyle: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.isTraining
                              ? AppColors.primary
                              : Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.isTraining
                              ? AppColors.primary
                              : Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => _updateExercise(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Wiederholungen',
                      labelStyle: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.isTraining
                              ? AppColors.primary
                              : Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.isTraining
                              ? AppColors.primary
                              : Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => _updateExercise(),
                  ),
                ),
              ],
            ),

            // Weight and Pause (only for Training)
            if (widget.isTraining) ...[
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Gewicht (kg)',
                  labelStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => _updateExercise(),
              ),

              const SizedBox(height: 16),

              // Pause Duration
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pauseDurationController,
                      enabled:
                          _isPauseDuration, // Nur aktiviert wenn Checkbox angehakt
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: _isPauseDuration
                            ? AppColors.textPrimary
                            : AppColors.textPrimary.withOpacity(0.5),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Pause (Sekunden)',
                        labelStyle: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isPauseDuration
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _updateExercise(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Text(
                        'Dauer-Pause',
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Checkbox(
                        value: _isPauseDuration,
                        onChanged: (value) {
                          setState(() {
                            _isPauseDuration = value ?? false;
                            // Wenn deaktiviert, lösche den Pausenwert
                            if (!_isPauseDuration) {
                              _pauseDurationController.clear();
                            } else {
                              // Wenn aktiviert, setze Standardwert
                              _pauseDurationController.text = '60';
                            }
                          });
                          _updateExercise();
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
