enum ClassLocation {
  virtual,
  physical,
  none,
}

extension ClassLocationExtensions on ClassLocation {
  static const Map<ClassLocation, String> _classLocationToString = {
    ClassLocation.virtual: 'Virtual',
    ClassLocation.physical: 'Physical',
    ClassLocation.none: 'None',
  };

  String get toName => _classLocationToString[this] ?? 'Virtual';

  static ClassLocation fromName(String value) {
    final normalizedValue = value.toLowerCase();

    return _classLocationToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(
            ClassLocation.virtual,
            'Virtual',
          ),
        )
        .key;
  }
}
