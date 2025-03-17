enum RecurrenceType {
  oneTime,
  daily,
  dailyWeekdays,
  weekly,
  monthly,
  none,
}

extension RecurrenceTypeExtensions on RecurrenceType {
  static const Map<RecurrenceType, String> _recurrenceToString = {
    RecurrenceType.oneTime: 'One-time',
    RecurrenceType.daily: 'Daily',
    RecurrenceType.dailyWeekdays: 'Daily (Weekdays)',
    RecurrenceType.weekly: 'Weekly',
    RecurrenceType.monthly: 'Monthly',
    RecurrenceType.none: 'None',
  };

  String get toName => _recurrenceToString[this] ?? 'None';

  static RecurrenceType fromName(String value) {
    final normalizedValue = value.trim().toLowerCase();
    return _recurrenceToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(RecurrenceType.none, 'None'),
        )
        .key;
  }
}
