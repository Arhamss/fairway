enum BreakoutRoomDuration {
  five(5),
  ten(10),
  fifteen(15),
  twenty(20),
  none(0);

  const BreakoutRoomDuration(this.duration);

  final int duration;
}

extension BreakoutRoomDurationExtensions on BreakoutRoomDuration {
  static const Map<BreakoutRoomDuration, String> _durationToString = {
    BreakoutRoomDuration.five: '5 min',
    BreakoutRoomDuration.ten: '10 min',
    BreakoutRoomDuration.fifteen: '15 min',
    BreakoutRoomDuration.twenty: '20 min',
    BreakoutRoomDuration.none: '0 min',
  };

  String get toName => _durationToString[this] ?? '0 min';

  static BreakoutRoomDuration fromName(String value) {
    final normalizedValue = value.toLowerCase();

    return _durationToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
      orElse: () => const MapEntry(BreakoutRoomDuration.none, '0 min'),
    )
        .key;
  }
}
