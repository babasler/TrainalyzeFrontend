// lib/models/mobility_section_dto.dart
import 'base_section.dart';
import 'section_type.dart';

class MobilitySection extends BaseSection {
  MobilitySection({
    super.id,
  }) : super(sectionType: SectionType.mobility);

  factory MobilitySection.fromJson(Map<String, dynamic> json) {
    return MobilitySection(
      id: json['id'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sectionType': sectionType.toJson(),
    };
  }
}