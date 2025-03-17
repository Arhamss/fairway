import 'package:hive_flutter/adapters.dart';

part 'language_proficiency_enum.g.dart';

@HiveType(typeId: 2)
enum LanguageProficiency {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
  @HiveField(3)
  none,
}

extension LanguageProficiencyExtensions on LanguageProficiency {
  static const Map<LanguageProficiency, String> _proficiencyToString = {
    LanguageProficiency.beginner: 'Beginner',
    LanguageProficiency.intermediate: 'Intermediate',
    LanguageProficiency.advanced: 'Advanced',
    LanguageProficiency.none: 'None',
  };

  String get toName => _proficiencyToString[this] ?? 'None';

  static LanguageProficiency fromName(String name) {
    final normalizedValue = name.toLowerCase();

    return _proficiencyToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(LanguageProficiency.none, 'None'),
        )
        .key;
  }
}
