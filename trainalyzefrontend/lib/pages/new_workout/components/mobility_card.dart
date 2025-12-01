import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/entities/workout/mobility_section.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
// mobility card uses mobility-specific UI, not the generic ExerciseCard

class MobilityCard extends StatefulWidget {
  final MobilitySection section;
  final Function(MobilitySection) onUpdate;

  const MobilityCard({
    super.key,
    required this.section,
    required this.onUpdate,
  });

  @override
  State<MobilityCard> createState() => _MobilityCardState();

}

class _MobilityCardState extends State<MobilityCard> {
  late List<MobilitySection> _exercises;

  @override
  void initState() {
    super.initState();
    // initialize exercises list to avoid uninitialized late errors
    _exercises = [];
  }

  void _addExercise() {
    setState(() {
      _exercises.add(MobilitySection());
    });
    _updateSection();
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
    _updateSection();
  }

  void _updateExercise(int index, MobilitySection exercise) {
    setState(() {
      _exercises[index] = exercise;
    });
    _updateSection();
  }

  void _updateSection() {
    // Notify parent about updates. Keep separation between mobility and
    // training logic by sending back the section as-is (parent can decide
    // how to merge exercises). This avoids passing mobility items into
    // widgets that expect training exercises.
    widget.onUpdate(widget.section);
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
            (index) {
              final ex = _exercises[index];
              return Card(
                key: ValueKey('mobility_exercise_$index'),
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.surface.withOpacity(0.5),
                child: ListTile(
                  leading: Icon(Icons.self_improvement, color: Colors.green),
                  title: Text(ex.name.isNotEmpty ? ex.name : 'Mobility Übung',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text('Sätze: ${ex.sets} • Wdh.: ${ex.reps}',
                      style: TextStyle(color: AppColors.textPrimary.withOpacity(0.7))),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red.withOpacity(0.7)),
                    onPressed: () => _removeExercise(index),
                  ),
                  onTap: () async {
                    // Simple inline edit dialog for name/sets/reps
                    final result = await showDialog<MobilitySection>(
                      context: context,
                      builder: (ctx) {
                        final nameController = TextEditingController(text: ex.name);
                        final setsController = TextEditingController(text: ex.sets.toString());
                        final repsController = TextEditingController(text: ex.reps.toString());
                        return AlertDialog(
                          title: Text('Mobility Übung bearbeiten'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                              TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sätze'), keyboardType: TextInputType.number),
                              TextField(controller: repsController, decoration: InputDecoration(labelText: 'Wdh.'), keyboardType: TextInputType.number),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Abbrechen')),
                            ElevatedButton(
                              onPressed: () {
                                final updated = MobilitySection(
                                    name: nameController.text,
                                    sets: int.tryParse(setsController.text) ?? 0,
                                    reps: int.tryParse(repsController.text) ?? 0,
                                );
                                Navigator.of(ctx).pop(updated);
                              },
                              child: Text('Speichern'),
                            ),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      _updateExercise(index, result);
                    }
                  },
                ),
              );
            },
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
