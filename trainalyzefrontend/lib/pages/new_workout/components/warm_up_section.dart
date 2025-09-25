import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/models/workout_model.dart';

class WarmUpSection extends StatefulWidget {
  final WorkoutSection section;
  final Function(WorkoutSection) onUpdate;

  const WarmUpSection({
    super.key,
    required this.section,
    required this.onUpdate,
  });

  @override
  State<WarmUpSection> createState() => _WarmUpSectionState();
}

class _WarmUpSectionState extends State<WarmUpSection> {
  late TextEditingController _durationController;
  late bool _isDurationWarmUp;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: widget.section.duration ?? '10:00',
    );
    _isDurationWarmUp = widget.section.isDurationWarmUp ?? true;
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _updateSection() {
    final updatedSection = WorkoutSection(
      type: SectionType.warmUp,
      duration: _isDurationWarmUp && _durationController.text.isNotEmpty
          ? _durationController.text
          : null,
      isDurationWarmUp: _isDurationWarmUp,
    );
    widget.onUpdate(updatedSection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Duration Input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _durationController,
                enabled:
                    _isDurationWarmUp, // Nur aktiviert wenn Checkbox angehakt
                style: TextStyle(
                  color: _isDurationWarmUp
                      ? AppColors.textPrimary
                      : AppColors.textPrimary.withOpacity(0.5),
                ),
                decoration: InputDecoration(
                  labelText: 'Dauer (mm:ss)',
                  labelStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                  hintText: '10:00',
                  hintStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDurationWarmUp
                          ? Colors.orange
                          : Colors.orange.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => _updateSection(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Duration Toggle
        Row(
          children: [
            Checkbox(
              value: _isDurationWarmUp,
              onChanged: (value) {
                setState(() {
                  _isDurationWarmUp = value ?? false;
                  // Wenn deaktiviert, lösche den Dauerwert
                  if (!_isDurationWarmUp) {
                    _durationController.clear();
                  } else {
                    // Wenn aktiviert, setze Standardwert
                    _durationController.text = '10:00';
                  }
                });
                _updateSection();
              },
              activeColor: Colors.orange,
            ),
            Expanded(
              child: Text(
                'Dauer-basiertes Warm Up',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Info Text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Das Warm Up bereitet deinen Körper auf das Training vor.',
                  style: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
