enum ClassStatus {
  completed,
  current,
  upcoming,
  none,
}

extension ClassStatusExtensions on ClassStatus {
  static const Map<ClassStatus, String> _classStatusToString = {
    ClassStatus.completed: 'Completed',
    ClassStatus.current: 'Current Class',
    ClassStatus.upcoming: 'Upcoming',
    ClassStatus.none: 'None',
  };

  String get toName => _classStatusToString[this] ?? 'None';

  static ClassStatus fromName(String value) {
    final normalizedValue = value.toLowerCase();

    return _classStatusToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(
            ClassStatus.none,
            'None',
          ),
        )
        .key;
  }
}
