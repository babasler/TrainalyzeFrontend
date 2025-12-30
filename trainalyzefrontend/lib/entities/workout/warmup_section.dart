// lib/models/warmup_section_dto.dart
import 'base_section.dart';
import 'section_type.dart';

class WarmUpSection extends BaseSection {
  String duration;
  bool isDurationWarmUp;

  WarmUpSection({
    super.id,
    required this.duration,
    required this.isDurationWarmUp,
  }) : super(sectionType: SectionType.warmup);

  factory WarmUpSection.fromJson(Map<String, dynamic> json) {
    return WarmUpSection(
      id: json['id'] as int?,
      duration: json['duration'] as String,
      isDurationWarmUp: json['isDurationWarmUp'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sectionType': sectionType.toJson(),
      'duration': duration,
      'isDurationWarmUp': isDurationWarmUp,
    };
  }
  

}