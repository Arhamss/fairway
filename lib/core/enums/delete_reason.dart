enum DeletionReason {
  none,
  betterAlternative,
  technicalIssues,
  notUsingAppEnough,
  other,
}

extension DeletionReasonExtensions on DeletionReason {
  static const Map<DeletionReason, String> _reasonToString = {
    DeletionReason.none: 'None',
    DeletionReason.betterAlternative: 'I found a better alternative',
    DeletionReason.technicalIssues: 'I’m having technical issues',
    DeletionReason.notUsingAppEnough: 'I’m not using this app enough',
    DeletionReason.other: 'Other',
  };

  String get toStringRepresentation => _reasonToString[this] ?? 'None';

  static DeletionReason fromString(String reason) {
    return _reasonToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == reason.toLowerCase(),
          orElse: () => const MapEntry(DeletionReason.none, 'None'),
        )
        .key;
  }
}
