// lib/models/base_section_dto.dart
import 'package:trainalyzefrontend/entities/workout/pause_section.dart';
import 'package:trainalyzefrontend/entities/workout/mobility_section.dart';
import 'package:trainalyzefrontend/entities/workout/training_section.dart';
import 'package:trainalyzefrontend/entities/workout/warmup_section.dart';

import 'section_type.dart';

abstract class BaseSection {
  int? id;
  SectionType sectionType;

  BaseSection({
    this.id,
    required this.sectionType,
  });

  Map<String, dynamic> toJson();

  factory BaseSection.fromJson(Map<String, dynamic> json) {
    final type = SectionType.fromString(json['sectionType'] as String);
    
    switch (type) {
      case SectionType.pause:
        return PauseSection.fromJson(json);
      case SectionType.warmup:
        return WarmUpSection.fromJson(json);
      case SectionType.training:
        return TrainingSection.fromJson(json);
      case SectionType.mobility:
        return MobilitySection.fromJson(json);
    }
  }
}