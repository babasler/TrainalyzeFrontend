import 'package:flutter/material.dart';
import 'dart:async';
import '../../../enviroment/env.dart';
import '../models/training_session_model.dart';

enum SessionType { warmUp, pause, exercise }

class SessionTimerWidget extends StatefulWidget {
  final PauseConfiguration pauseConfig;
  final VoidCallback onComplete;
  final VoidCallback? onSkip; // Optional - null bedeutet nicht überspringbar
  final SessionType sessionType; // Bestimmt die UI-Texte
  final String? customTitle; // Optional: Überschreibt Standard-Titel

  const SessionTimerWidget({
    super.key,
    required this.pauseConfig,
    required this.onComplete,
    required this.sessionType,
    this.onSkip,
    this.customTitle,
  });

  @override
  State<SessionTimerWidget> createState() => _SessionTimerWidgetState();
}

class _SessionTimerWidgetState extends State<SessionTimerWidget> {
  Timer? _timer;
  Duration _currentDuration = Duration.zero;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isPaused = false;
    });

    if (widget.pauseConfig.type == PauseType.fixed) {
      // Countdown Timer - startet bei der festgelegten Zeit
      _currentDuration = widget.pauseConfig.fixedDuration!;
    } else {
      // Stopuhr - startet bei 0
      _currentDuration = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          if (widget.pauseConfig.type == PauseType.fixed) {
            // Countdown
            if (_currentDuration > Duration.zero) {
              _currentDuration = _currentDuration - const Duration(seconds: 1);
            } else {
              // Timer abgelaufen
              timer.cancel();
              widget.onComplete();
            }
          } else {
            // Stopuhr
            _currentDuration = _currentDuration + const Duration(seconds: 1);
          }
        });
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
    // Timer läuft weiter, aber _isPaused kontrolliert ob die Zeit sich ändert
    // Kein Neustart nötig - der Timer.periodic läuft weiter und prüft _isPaused
  }

  void _completeTimer() {
    _timer?.cancel();
    widget.onComplete();
  }

  void _skipTimer() {
    _timer?.cancel();
    widget.onSkip?.call();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  double _getProgress() {
    if (widget.pauseConfig.type == PauseType.fixed &&
        widget.pauseConfig.fixedDuration != null) {
      final total = widget.pauseConfig.fixedDuration!.inSeconds;
      final remaining = _currentDuration.inSeconds;
      return 1.0 - (remaining / total);
    }
    return 0.0; // Für individuelle Timer kein Fortschritt
  }

  Color _getTimerColor() {
    if (widget.pauseConfig.type == PauseType.fixed) {
      final progress = _getProgress();
      if (progress < 0.5) {
        return AppColors.primary;
      } else if (progress < 0.8) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }
    return AppColors.primary;
  }

  String _getPauseButtonText() {
    switch (widget.sessionType) {
      case SessionType.warmUp:
        return _isPaused ? 'Aufwärmen fortsetzen' : 'Aufwärmen pausieren';
      case SessionType.pause:
        return _isPaused ? 'Pause fortsetzen' : 'Pause pausieren';
      case SessionType.exercise:
        return _isPaused ? 'Fortsetzen' : 'Pausieren';
    }
  }

  String _getContinueButtonText() {
    switch (widget.sessionType) {
      case SessionType.warmUp:
        return 'Aufwärmen beenden';
      case SessionType.pause:
        return 'Pause beenden';
      case SessionType.exercise:
        return 'Weiter';
    }
  }

  String _getSkipButtonText() {
    switch (widget.sessionType) {
      case SessionType.warmUp:
        return 'Überspringen';
      case SessionType.pause:
        return 'Überspringen';
      case SessionType.exercise:
        return 'Überspringen';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final timerSize = isLandscape ? 150.0 : 200.0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(isLandscape ? 16 : 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Timer Display
            SizedBox(
              width: timerSize,
              height: timerSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Zeit-Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(_currentDuration),
                        style: TextStyle(
                          fontSize: isLandscape ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: _getTimerColor(),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (widget.customTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.customTitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isLandscape ? 16 : 24),
            // Timer Controls
            _buildTimerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControls() {
    if (_currentDuration <= Duration.zero &&
        widget.pauseConfig.type == PauseType.fixed) {
      // Timer abgelaufen - nur "Weiter" Button
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _completeTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow),
              const SizedBox(width: 8),
              Text(
                _getContinueButtonText(),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    // Für individuelle Timer oder wenn Skip nicht erlaubt ist
    if (widget.pauseConfig.type == PauseType.individual ||
        widget.onSkip == null) {
      return Column(
        children: [
          // Pause/Resume Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _pauseTimer,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: _getTimerColor()),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    color: _getTimerColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPauseButtonText(),
                    style: TextStyle(color: _getTimerColor()),
                  ),
                ],
              ),
            ),
          ),
          if (widget.pauseConfig.type == PauseType.individual) ...[
            const SizedBox(height: 12),
            // Continue Button für individuelle Timer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(
                      _getContinueButtonText(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    }

    // Standard: Pause/Resume und Skip Button
    return Row(
      children: [
        // Pause/Resume Button
        Expanded(
          child: OutlinedButton(
            onPressed: _pauseTimer,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: _getTimerColor()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
                  color: _getTimerColor(),
                ),
                const SizedBox(width: 8),
                Text(
                  _getPauseButtonText(),
                  style: TextStyle(color: _getTimerColor()),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Skip Button (nur wenn erlaubt)
        Expanded(
          child: ElevatedButton(
            onPressed: _skipTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.skip_next),
                const SizedBox(width: 8),
                Text(
                  _getSkipButtonText(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
