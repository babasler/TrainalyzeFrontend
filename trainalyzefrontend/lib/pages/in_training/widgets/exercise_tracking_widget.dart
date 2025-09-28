import 'package:flutter/material.dart';
import '../../../enviroment/env.dart';
import '../models/training_session_model.dart';

class ExerciseTrackingWidget extends StatefulWidget {
  final TrainingExerciseSession exercise;
  final VoidCallback onSetCompleted;
  final VoidCallback onExerciseCompleted;

  const ExerciseTrackingWidget({
    super.key,
    required this.exercise,
    required this.onSetCompleted,
    required this.onExerciseCompleted,
  });

  @override
  State<ExerciseTrackingWidget> createState() => _ExerciseTrackingWidgetState();
}

class _ExerciseTrackingWidgetState extends State<ExerciseTrackingWidget> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  bool _showInputs = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _completeSet() {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);

    if (weight != null && reps != null) {
      final currentSet = widget.exercise.sets[widget.exercise.currentSetIndex];
      currentSet.complete(weight, reps);

      setState(() {
        _showInputs = false;
        _weightController.clear();
        _repsController.clear();
      });

      widget.onSetCompleted();

      if (widget.exercise.isCompleted) {
        widget.onExerciseCompleted();
      }
    }
  }

  void _startSet() {
    final currentSet = widget.exercise.sets[widget.exercise.currentSetIndex];
    currentSet.startTime = DateTime.now();
    setState(() {
      _showInputs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercise.isCompleted) {
      return _buildCompletedExercise();
    }

    final currentSet = widget.exercise.sets[widget.exercise.currentSetIndex];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseHeader(),
            const SizedBox(height: 16),
            _buildSetProgress(),
            const SizedBox(height: 16),
            _buildTargetInfo(currentSet),
            if (widget.exercise.lastWorkoutData != null) ...[
              const SizedBox(height: 8),
              _buildLastWorkoutInfo(),
            ],
            const SizedBox(height: 16),
            _buildSetActions(currentSet),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getSectionColor(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.exercise.section.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.exercise.exerciseName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSetProgress() {
    return Row(
      children: [
        Text(
          'Satz ${widget.exercise.currentSetIndex + 1}/${widget.exercise.sets.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        ...List.generate(widget.exercise.sets.length, (index) {
          final set = widget.exercise.sets[index];
          return Container(
            margin: const EdgeInsets.only(left: 4),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: set.isCompleted
                  ? Colors.green
                  : index == widget.exercise.currentSetIndex
                  ? AppColors.primary
                  : Colors.grey[300],
            ),
            child: set.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          );
        }),
      ],
    );
  }

  Widget _buildTargetInfo(TrainingSetSession currentSet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            'Ziel: ${currentSet.targetWeight}kg × ${currentSet.targetReps} Wdh.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastWorkoutInfo() {
    final lastData = widget.exercise.lastWorkoutData!;
    final currentSetIndex = widget.exercise.currentSetIndex;

    if (currentSetIndex < lastData.sets.length) {
      final lastSet = lastData.sets[currentSetIndex];
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.history, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Letztes: ${lastSet.weight}kg × ${lastSet.reps}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildSetActions(TrainingSetSession currentSet) {
    if (!_showInputs && currentSet.startTime == null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _startSet,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Satz starten', style: TextStyle(fontSize: 16)),
        ),
      );
    }

    if (_showInputs) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tatsächlich bewegt:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Gewicht (kg)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Wiederholungen',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _completeSet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Satz abschließen',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildCompletedExercise() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.exercise.sets.length} Sätze abgeschlossen',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSectionColor() {
    switch (widget.exercise.section) {
      case 'warmup':
        return Colors.orange;
      case 'training':
        return AppColors.primary;
      case 'mobility':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
