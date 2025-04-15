enum OrderMethod {
  pickYourself,
  concierge,
}

extension OrderMethodExtension on OrderMethod {
  String get toName {
    switch (this) {
      case OrderMethod.pickYourself:
        return 'pickup';
      case OrderMethod.concierge:
        return 'concierge';
    }
  }
}
