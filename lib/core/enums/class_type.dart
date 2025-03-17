enum ClassType {
  individualPremium,
  groupPremium,
  groupStandard,
}

extension ClassTypeExtensions on ClassType {
  static const Map<ClassType, String> _classTypeToString = {
    ClassType.individualPremium: 'Individual Premium',
    ClassType.groupPremium: 'Group Premium',
    ClassType.groupStandard: 'Group Standard',
  };

  String get toName => _classTypeToString[this] ?? 'Individual Premium';

  static ClassType fromString(String value) {
    final normalizedValue = value.toLowerCase();

    return _classTypeToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(
            ClassType.individualPremium,
            'Individual Premium',
          ),
        )
        .key;
  }
}
