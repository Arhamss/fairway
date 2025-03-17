import 'package:hive_flutter/adapters.dart';

part 'subscription_enum.g.dart';

@HiveType(typeId: 7)
enum SubscriptionType {
  @HiveField(0)
  unlimitedCredits,
  @HiveField(1)
  bammbuuGroups,
  @HiveField(2)
  none,
}

extension SubscriptionTypeExtensions on SubscriptionType {
  static const Map<SubscriptionType, String> _subscriptionToString = {
    SubscriptionType.unlimitedCredits: 'Unlimited Credits',
    SubscriptionType.bammbuuGroups: 'Bammbuu Groups',
    SubscriptionType.none: 'None',
  };

  String get toName => _subscriptionToString[this] ?? 'None';

  static SubscriptionType fromName(String value) {
    final normalizedValue = value.trim().toLowerCase();
    return _subscriptionToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(SubscriptionType.none, 'None'),
        )
        .key;
  }
}

@HiveType(typeId: 11)
enum SubscriptionStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  inactive,
  @HiveField(2)
  none,
}

extension SubscriptionStatusExtensions on SubscriptionStatus {
  static const Map<SubscriptionStatus, String> _subscriptionStatusToString = {
    SubscriptionStatus.active: 'Active',
    SubscriptionStatus.inactive: 'Inactive',
    SubscriptionStatus.none: 'None',
  };

  String get toName => _subscriptionStatusToString[this] ?? 'None';

  static SubscriptionStatus fromName(String value) {
    final normalizedValue = value.trim().toLowerCase();
    return _subscriptionStatusToString.entries
        .firstWhere(
          (entry) => entry.value.toLowerCase() == normalizedValue,
          orElse: () => const MapEntry(SubscriptionStatus.none, 'None'),
        )
        .key;
  }
}
