enum LanguageTypeEnum {
  english,
  spanish,
}

extension ClassLanguageTypeExtensions on LanguageTypeEnum {
  static const Map<LanguageTypeEnum, String> _languageTypeToString = {
    LanguageTypeEnum.english: 'ENG-English',
    LanguageTypeEnum.spanish: 'DE-Spanish',
  };

  static const Map<LanguageTypeEnum, String> toLanguageCode = {
    LanguageTypeEnum.english: 'en',
    LanguageTypeEnum.spanish: 'es',
  };

  static const Map<String, LanguageTypeEnum> fromLanguageCode = {
    'en': LanguageTypeEnum.english,
    'es': LanguageTypeEnum.spanish,
  };

  String get toName => _languageTypeToString[this] ?? 'ENG-English';

  String get toCode => toLanguageCode[this] ?? 'en';

  static LanguageTypeEnum fromCode(String code) {
    return fromLanguageCode[code] ?? LanguageTypeEnum.english;
  }

  static LanguageTypeEnum fromName(String value) {
    final normalizedValue = value.toLowerCase();

    return _languageTypeToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(
            LanguageTypeEnum.english,
            'ENG-English',
          ),
        )
        .key;
  }
}
