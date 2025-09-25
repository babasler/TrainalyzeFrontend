import 'package:flutter/material.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/pages/new_workout/models/workout_model.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/warm_up_section.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/training_section.dart';
import 'package:trainalyzefrontend/pages/new_workout/components/mobility_section.dart';

class SectionCard extends StatelessWidget {
  final WorkoutSection section;
  final Function(WorkoutSection) onUpdate;
  final VoidCallback onRemove;

  const SectionCard({
    super.key,
    required this.section,
    required this.onUpdate,
    required this.onRemove,
  });

  String _getSectionTitle() {
    switch (section.type) {
      case SectionType.warmUp:
        return 'Warm Up';
      case SectionType.training:
        return 'Training';
      case SectionType.mobility:
        return 'Mobility';
    }
  }

  IconData _getSectionIcon() {
    switch (section.type) {
      case SectionType.warmUp:
        return Icons.whatshot;
      case SectionType.training:
        return Icons.fitness_center;
      case SectionType.mobility:
        return Icons.self_improvement;
    }
  }

  Color _getSectionColor() {
    switch (section.type) {
      case SectionType.warmUp:
        return Colors.orange;
      case SectionType.training:
        return AppColors.primary;
      case SectionType.mobility:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getSectionColor().withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getSectionColor().withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(_getSectionIcon(), color: _getSectionColor(), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getSectionTitle(),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSectionContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (section.type) {
      case SectionType.warmUp:
        return WarmUpSection(section: section, onUpdate: onUpdate);
      case SectionType.training:
        return TrainingSection(section: section, onUpdate: onUpdate);
      case SectionType.mobility:
        return MobilitySection(section: section, onUpdate: onUpdate);
    }
  }
}
