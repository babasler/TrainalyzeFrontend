import 'package:flutter/material.dart';
import 'dart:async';
import '../../../enviroment/env.dart';
import '../models/training_session_model.dart';

class PauseTimerWidget extends StatefulWidget {
  final PauseConfiguration pauseConfig;
  final VoidCallback onPauseComplete;
  final VoidCallback?
  onSkipPause; // Optional - null bedeutet nicht überspringbar

  const PauseTimerWidget({
    super.key,
    required this.pauseConfig,
    required this.onPauseComplete,
    this.onSkipPause,
  });

  @override
  State<PauseTimerWidget> createState() => _PauseTimerWidgetState();
}

class _PauseTimerWidgetState extends State<PauseTimerWidget> {
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
            // Countdown: Zeit reduzieren
            _currentDuration = _currentDuration - const Duration(seconds: 1);

            // Timer abgelaufen
            if (_currentDuration <= Duration.zero) {
              _currentDuration = Duration.zero;
              _completeTimer();
            }
          } else {
            // Stopuhr: Zeit erhöhen
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
    widget.onPauseComplete();
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
    return 0.0; // Für individuelle Pausen kein Fortschritt
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTimerHeader(),
            const SizedBox(height: 20),
            _buildTimerDisplay(),
            const SizedBox(height: 20),
            _buildTimerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerHeader() {
    return Row(
      children: [
        Icon(Icons.timer_outlined, color: _getTimerColor(), size: 28),
        const SizedBox(width: 12),
        Text(
          widget.pauseConfig.type == PauseType.fixed
              ? 'Pause Timer'
              : 'Freie Pause',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getTimerColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: _getTimerColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getTimerColor().withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            _formatDuration(_currentDuration),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _getTimerColor(),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (widget.pauseConfig.type == PauseType.fixed) ...[
            const SizedBox(height: 8),
            Text(
              _currentDuration <= Duration.zero
                  ? 'Zeit ist um!'
                  : 'verbleibend',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'verstrichene Zeit',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ],
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow),
              SizedBox(width: 8),
              Text('Weiter', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    // Für individuelle Pausen oder wenn Skip nicht erlaubt ist
    if (widget.pauseConfig.type == PauseType.individual ||
        widget.onSkipPause == null) {
      return Column(
        children: [
          // Nur Pause/Resume Button
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
                    _isPaused ? 'Fortsetzen' : 'Pause',
                    style: TextStyle(color: _getTimerColor()),
                  ),
                ],
              ),
            ),
          ),
          if (widget.pauseConfig.type == PauseType.individual) ...[
            const SizedBox(height: 12),
            // Weiter Button für individuelle Pausen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text('Weiter', style: TextStyle(fontSize: 16)),
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
                  _isPaused ? 'Fortsetzen' : 'Pause',
                  style: TextStyle(color: _getTimerColor()),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Skip Button (nur wenn erlaubt)
      ],
    );
  }
}
