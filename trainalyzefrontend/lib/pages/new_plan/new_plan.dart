import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_plan/models/training_plan_model.dart';

class NewPlan extends StatefulWidget {
  const NewPlan({super.key});

  @override
  State<NewPlan> createState() => _NewPlanState();
}

class _NewPlanState extends State<NewPlan> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();

  late TrainingPlanModel _trainingPlan;

  // Dummy-Workouts für die Auswahl
  final List<String> _availableWorkouts = [
    'Push Day',
    'Pull Day',
    'Leg Day',
    'Upper Body',
    'Lower Body',
    'Full Body A',
    'Full Body B',
    'Chest & Triceps',
    'Back & Biceps',
    'Shoulders & Core',
    'HIIT Cardio',
    'Mobility Flow',
  ];

  @override
  void initState() {
    super.initState();
    _trainingPlan = TrainingPlanModel(name: '');
  }

  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }

  void _updateWorkoutForDay(int day, String? workout) {
    setState(() {
      _trainingPlan.selectedWorkouts[day] = workout ?? '';
    });
  }

  Future<void> _saveTrainingPlan() async {
    if (_formKey.currentState?.validate() ?? false) {
      _trainingPlan.name = _planNameController.text;

      // JSON generieren
      final json = _trainingPlan.toJson();
      print('💾 Trainingsplan JSON:');
      print(json);

      // TODO: Backend-Integration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trainingsplan "${_trainingPlan.name}" gespeichert!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Widget _buildWeekDayCard(int dayNumber) {
    final dayName = TrainingPlanModel.getWeekDayName(dayNumber);
    final selectedWorkout = _trainingPlan.selectedWorkouts[dayNumber] ?? '';
    final isRestDay = selectedWorkout.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRestDay
              ? AppColors.textPrimary.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Wochentag
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tag $dayNumber',
                    style: TextStyle(
                      color: AppColors.textPrimary.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Workout-Dropdown oder Ruhetag
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedWorkout.isEmpty ? null : selectedWorkout,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Ruhetag oder Workout auswählen',
                  hintStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isRestDay
                          ? AppColors.textPrimary.withOpacity(0.3)
                          : AppColors.primary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                dropdownColor: AppColors.surface,
                items: [
                  // Ruhetag Option
                  DropdownMenuItem<String>(
                    value: '',
                    child: Row(
                      children: [
                        Icon(
                          Icons.bed,
                          color: AppColors.textPrimary.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ruhetag',
                          style: TextStyle(
                            color: AppColors.textPrimary.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Workout Optionen
                  ..._availableWorkouts.map(
                    (workout) => DropdownMenuItem<String>(
                      value: workout,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              workout,
                              style: TextStyle(color: AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => _updateWorkoutForDay(dayNumber, value),
              ),
            ),
          ],
        ),
      ),
    );
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
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Neuen Trainingsplan erstellen',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _planNameController,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Trainingsplan Name',
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
                          return 'Bitte einen Trainingsplan-Namen eingeben';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Wochentage Liste
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wochenplanung',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Wähle für jeden Wochentag ein Workout aus oder lasse den Tag als Ruhetag.',
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Wochentage
                      ...List.generate(
                        7,
                        (index) => _buildWeekDayCard(index + 1),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Speichern Button
              Container(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTrainingPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Trainingsplan speichern',
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
