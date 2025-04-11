enum RestaurantTag {
  nearby,
  discounts,
  quickServe,
  drinks,
}

extension RestaurantTagExtension on RestaurantTag {
  /// Returns the raw enum name
  String toEnumName() => name;

  /// Returns a nicely formatted display name
  String toCapitalized() {
    switch (this) {
      case RestaurantTag.nearby:
        return 'Nearby';
      case RestaurantTag.discounts:
        return 'Discounts';
      case RestaurantTag.quickServe:
        return 'Quick Serve';
      case RestaurantTag.drinks:
        return 'Drinks';
    }
  }

  /// Parse from string (raw enum name)
  static RestaurantTag fromString(String value) {
    return RestaurantTag.values.firstWhere(
      (tag) => tag.name == value,
      orElse: () => throw ArgumentError('Invalid RestaurantTag: $value'),
    );
  }
}
