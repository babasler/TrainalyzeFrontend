import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../enviroment/env.dart';
import 'models/training_session_model.dart';
import 'widgets/exercise_tracking_widget.dart';
import 'widgets/pause_timer_widget.dart';
import 'widgets/session_timer_widget.dart';

class InTrainingPage extends StatefulWidget {
  const InTrainingPage({super.key});

  @override
  State<InTrainingPage> createState() => _InTrainingPageState();
}

class _InTrainingPageState extends State<InTrainingPage> {
  late TrainingSessionModel _session;
  Timer? _sessionTimer;
  bool _isInPause = false;
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _initializeSession() {
    // Dummy-Daten für das aktuelle Training
    _session = TrainingSessionModel(
      workoutName: 'Push Training',
      startTime: DateTime.now(),
      items: [
        // Warm-Up
        WarmUpSession(
          exerciseId: 'warmup_1',
          exerciseName: 'Aufwärmen',
          duration: '',
          isDurationBased: false,
        ),
        // Training Übungen
        TrainingExerciseSession(
          exerciseId: 'exercise_1',
          exerciseName: 'Bankdrücken',
          section: 'training',
          pauseConfig: PauseConfiguration(
            type: PauseType.fixed,
            fixedDuration: const Duration(minutes: 1, seconds: 30),
          ),
          lastWorkoutData: ExerciseHistoryData(
            lastWorkoutDate: DateTime.now().subtract(const Duration(days: 2)),
            sets: [
              HistorySet(weight: 60, reps: 10),
              HistorySet(weight: 70, reps: 8),
              HistorySet(weight: 75, reps: 6),
            ],
          ),
          sets: [
            TrainingSetSession(targetWeight: 65, targetReps: 10),
            TrainingSetSession(targetWeight: 75, targetReps: 8),
            TrainingSetSession(targetWeight: 80, targetReps: 6),
          ],
        ),
        // Pause zwischen Übungen
        PauseSession(duration: '2:00', isDurationBased: true),
        TrainingExerciseSession(
          exerciseId: 'exercise_2',
          exerciseName: 'Schrägbankdrücken',
          section: 'training',
          pauseConfig: PauseConfiguration(type: PauseType.individual),
          lastWorkoutData: ExerciseHistoryData(
            lastWorkoutDate: DateTime.now().subtract(const Duration(days: 2)),
            sets: [
              HistorySet(weight: 50, reps: 12),
              HistorySet(weight: 55, reps: 10),
              HistorySet(weight: 60, reps: 8),
            ],
          ),
          sets: [
            TrainingSetSession(targetWeight: 55, targetReps: 12),
            TrainingSetSession(targetWeight: 60, targetReps: 10),
            TrainingSetSession(targetWeight: 65, targetReps: 8),
          ],
        ),
        // Pause zwischen Übungen
        PauseSession(duration: '1:30', isDurationBased: true),
        TrainingExerciseSession(
          exerciseId: 'exercise_3',
          exerciseName: 'Butterfly',
          section: 'mobility',
          pauseConfig: PauseConfiguration(
            type: PauseType.fixed,
            fixedDuration: const Duration(seconds: 45),
          ),
          sets: [
            TrainingSetSession(targetWeight: 40, targetReps: 15),
            TrainingSetSession(targetWeight: 45, targetReps: 12),
          ],
        ),
      ],
    );
    _isSessionActive = true;
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isSessionActive && mounted) {
        setState(() {
          // Timer läuft - UI wird automatisch aktualisiert
        });
      }
    });
  }

  void _onSetCompleted() {
    setState(() {
      _isInPause = true;
    });
  }

  void _onPauseComplete() {
    setState(() {
      _isInPause = false;
    });
  }

  void _onSkipPause() {
    setState(() {
      _isInPause = false;
    });
  }

  void _onExerciseCompleted() {
    if (_session.isCompleted) {
      _completeWorkout();
    } else {
      setState(() {
        _isInPause = true;
      });
    }
  }

  void _completeWorkout() {
    _sessionTimer?.cancel();
    setState(() {
      _isSessionActive = false;
      _session.endTime = DateTime.now();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Training abgeschlossen! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Trainingszeit: ${_formatDuration(_session.getCurrentDuration())}',
            ),
            const SizedBox(height: 8),
            Text(
              'Sätze abgeschlossen: ${_session.completedSetsCount}/${_session.totalSetsCount}',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Schließt den Dialog
              context.go('/dashboard'); // Navigiert explizit zum Dashboard
            },
            child: const Text('Zum Dashboard'),
          ),
        ],
      ),
    );
  }

  void _pauseWorkout() {
    setState(() {
      _isSessionActive = !_isSessionActive;
    });
  }

  void _stopWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training beenden?'),
        content: const Text(
          'Möchten Sie das Training wirklich beenden? Der Fortschritt wird gespeichert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _completeWorkout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Beenden', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inHours);
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    }
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      int minutes = int.tryParse(parts[0]) ?? 0;
      int seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  Widget _buildWarmUpWidget(WarmUpSession warmUp) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.whatshot, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  warmUp.exerciseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (warmUp.isDurationBased && warmUp.duration != null) ...[
                  Text(
                    'Aufwärmzeit: ${warmUp.duration}',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Timer für zeitbasiertes Warm-Up (Countdown)
                  SessionTimerWidget(
                    pauseConfig: PauseConfiguration(
                      type: PauseType.fixed,
                      fixedDuration: _parseDuration(warmUp.duration!),
                    ),
                    sessionType: SessionType.warmUp,
                    customTitle: 'Aufwärmen',
                    onComplete: () {
                      setState(() {
                        warmUp.complete();
                        _moveToNextItem();
                      });
                    },
                  ),
                ] else ...[
                  Text(
                    'Individuelles Aufwärmen',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wärmen Sie sich in Ihrem Tempo auf.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Stopwatch für individuelles Warm-Up (Timer läuft hoch)
                  SessionTimerWidget(
                    pauseConfig: PauseConfiguration(type: PauseType.individual),
                    sessionType: SessionType.warmUp,
                    customTitle: 'Aufwärmen',
                    onComplete: () {
                      setState(() {
                        warmUp.complete();
                        _moveToNextItem();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseWidget(PauseSession pause) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.coffee, size: 48, color: Colors.amber),
                const SizedBox(height: 16),
                const Text(
                  'Pause zwischen Übungen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Dauer: ${pause.duration}',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
                ),
                const SizedBox(height: 20),
                SessionTimerWidget(
                  pauseConfig: PauseConfiguration(
                    type: PauseType.fixed,
                    fixedDuration: _parseDuration(pause.duration),
                  ),
                  sessionType: SessionType.pause,
                  customTitle: 'Pause zwischen Übungen',
                  onComplete: () {
                    setState(() {
                      pause.complete();
                      _moveToNextItem();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _moveToNextItem() {
    if (_session.currentItemIndex < _session.items.length - 1) {
      // Zum nächsten Item
      setState(() {});
    } else {
      // Training abgeschlossen
      _completeWorkout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          _session.workoutName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _pauseWorkout,
            icon: Icon(_isSessionActive ? Icons.pause : Icons.play_arrow),
            tooltip: _isSessionActive
                ? 'Training pausieren'
                : 'Training fortsetzen',
          ),
          IconButton(
            onPressed: _stopWorkout,
            icon: const Icon(Icons.stop, color: Colors.red),
            tooltip: 'Training beenden',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSessionHeader(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gesamte Trainingszeit
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                color: _isSessionActive ? AppColors.primary : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_session.getCurrentDuration()),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isSessionActive ? AppColors.primary : Colors.orange,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fortschritt
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressItem(
                'Übung',
                '${_session.currentItemIndex + 1}/${_session.items.length}',
                Icons.fitness_center,
              ),
              _buildProgressItem(
                'Sätze',
                '${_session.completedSetsCount}/${_session.totalSetsCount}',
                Icons.format_list_numbered,
              ),
              _buildProgressItem(
                'Status',
                _isSessionActive ? 'Aktiv' : 'Pausiert',
                _isSessionActive ? Icons.play_circle : Icons.pause_circle,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Training beenden Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _stopWorkout,
              icon: const Icon(Icons.stop, color: Colors.red),
              label: const Text(
                'Training beenden',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (!_isSessionActive) {
      return _buildPausedState();
    }

    if (_isInPause) {
      final currentItem = _session.items[_session.currentItemIndex];
      if (currentItem is TrainingExerciseSession) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Pause nach Satz ${currentItem.currentSetIndex}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentItem.exerciseName,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              ),
              PauseTimerWidget(
                pauseConfig: currentItem.pauseConfig,
                onPauseComplete: _onPauseComplete,
                onSkipPause: _onSkipPause,
              ),
            ],
          ),
        );
      } else if (currentItem is PauseSession) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Pause zwischen Übungen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PauseTimerWidget(
                pauseConfig: PauseConfiguration(
                  type: PauseType.fixed,
                  fixedDuration: _parseDuration(currentItem.duration),
                ),
                onPauseComplete: _onPauseComplete,
              ),
            ],
          ),
        );
      }
    }

    final currentItem = _session.items[_session.currentItemIndex];

    if (currentItem is WarmUpSession) {
      return _buildWarmUpWidget(currentItem);
    } else if (currentItem is TrainingExerciseSession) {
      return SingleChildScrollView(
        child: ExerciseTrackingWidget(
          exercise: currentItem,
          onSetCompleted: _onSetCompleted,
          onExerciseCompleted: _onExerciseCompleted,
        ),
      );
    } else if (currentItem is PauseSession) {
      return _buildPauseWidget(currentItem);
    }

    return const Center(child: Text('Unbekannter Item-Typ'));
  }

  Widget _buildPausedState() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pause_circle, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Training pausiert',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Zeit: ${_formatDuration(_session.getCurrentDuration())}',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pauseWorkout,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Training fortsetzen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
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
