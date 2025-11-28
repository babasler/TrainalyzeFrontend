// lib/models/section_type.dart
enum SectionType {
  warmup('WARMUP'),
  training('TRAINING'),
  mobility('MOBILITY'),
  pause('PAUSE');

  final String value;
  const SectionType(this.value);

  static SectionType fromString(String value) {
    return SectionType.values.firstWhere(
      (type) => type.value == value.toUpperCase(),
      orElse: () => SectionType.training,
    );
  }

  String toJson() => value;
}