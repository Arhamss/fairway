enum ClassDuration {
  thirty(30),
  sixty(60),
  ninety(90),
  oneTwenty(120),
  none(0);

  const ClassDuration(this.duration);

  final int duration;
}

extension ClassDurationExtensions on ClassDuration {
  static const Map<ClassDuration, String> _durationToString = {
    ClassDuration.thirty: '30 min',
    ClassDuration.sixty: '60 min',
    ClassDuration.ninety: '90 min',
    ClassDuration.oneTwenty: '120 min',
    ClassDuration.none: '0 min',
  };

  String get toName => _durationToString[this] ?? '0 min';

  static ClassDuration fromName(String value) {
    final normalizedValue = value.toLowerCase();

    return _durationToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(ClassDuration.none, '0 min'),
        )
        .key;
  }
}
