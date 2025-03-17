import 'package:hive_flutter/adapters.dart';

part 'learning_language_enum.g.dart';

@HiveType(typeId: 1)
enum LearningLanguageEnum {
  @HiveField(0)
  english,
  @HiveField(1)
  spanish,
  @HiveField(2)
  englishSpanish,
  @HiveField(3)
  none,
}

extension LearningLanguageEnumExtensions on LearningLanguageEnum {
  static const _languageData = [
    {'id': '1', 'name': 'English'},
    {'id': '2', 'name': 'Spanish'},
    {'id': '3', 'name': 'English-Spanish'},
  ];

  static Future<List<Map<String, String>>> loadLearningLanguages() async {
    return Future.value(_languageData);
  }

  String? get toId {
    switch (this) {
      case LearningLanguageEnum.english:
        return '1';
      case LearningLanguageEnum.spanish:
        return '2';
      case LearningLanguageEnum.englishSpanish:
        return '3';
      case LearningLanguageEnum.none:
        return null;
    }
  }

  String get toName {
    switch (this) {
      case LearningLanguageEnum.english:
        return 'English';
      case LearningLanguageEnum.spanish:
        return 'Spanish';
      case LearningLanguageEnum.englishSpanish:
        return 'English-Spanish';
      case LearningLanguageEnum.none:
        return 'None';
    }
  }

  static LearningLanguageEnum? fromId(String id) {
    switch (id) {
      case '1':
        return LearningLanguageEnum.english;
      case '2':
        return LearningLanguageEnum.spanish;
      case '3':
        return LearningLanguageEnum.englishSpanish;
      default:
        return null;
    }
  }

  static LearningLanguageEnum? fromName(String name) {
    final normalizedName = name.toLowerCase();

    switch (normalizedName) {
      case 'english':
        return LearningLanguageEnum.english;
      case 'spanish':
        return LearningLanguageEnum.spanish;
      case 'english-spanish':
        return LearningLanguageEnum.englishSpanish;
      default:
        return null;
    }
  }
}
