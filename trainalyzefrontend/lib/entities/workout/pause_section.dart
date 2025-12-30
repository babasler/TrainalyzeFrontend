// lib/models/pause_section_dto.dart
import 'base_section.dart';
import 'section_type.dart';

class PauseSection extends BaseSection {
  String? duration;
  bool isDurationPause;

  PauseSection({
    super.id,
    this.duration,
    required this.isDurationPause,
  }) : super(sectionType: SectionType.pause);

  factory PauseSection.fromJson(Map<String, dynamic> json) {
    return PauseSection(
      id: json['id'] as int?,
      duration: json['duration'] as String?,
      isDurationPause: json['isDurationPause'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sectionType': sectionType.toJson(),
      'duration': duration,
      'isDurationPause': isDurationPause,
    };
  }
}