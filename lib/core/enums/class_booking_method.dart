enum ClassBookingMethod {
  subscription,
  credits,
  none,
}

extension ClassBookingMethodExtensions on ClassBookingMethod {
  static const Map<ClassBookingMethod, String> _classTypeToString = {
    ClassBookingMethod.subscription: 'Subscription',
    ClassBookingMethod.credits: 'Credits',
    ClassBookingMethod.none: 'None',
  };

  String get toName => _classTypeToString[this] ?? 'None';

  static ClassBookingMethod fromString(String value) {
    final normalizedValue = value.toLowerCase();

    return _classTypeToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(
            ClassBookingMethod.none,
            'None',
          ),
        )
        .key;
  }
}
