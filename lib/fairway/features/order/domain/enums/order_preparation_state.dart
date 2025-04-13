enum OrderPreparationState {
  preparing,
  pickedByConcierge,
  delivered,
  pickedByCustomer;

  String get title {
    switch (this) {
      case OrderPreparationState.preparing:
        return 'Preparing your order';
      case OrderPreparationState.pickedByConcierge:
        return 'Concierge has picked your order';
      case OrderPreparationState.delivered:
        return 'Concierge delivered your order';
      case OrderPreparationState.pickedByCustomer:
        return 'You picked your order';
    }
  }

  String get description {
    switch (this) {
      case OrderPreparationState.preparing:
        return 'We are preparing your food with magic and care';
      case OrderPreparationState.pickedByConcierge:
        return 'Your order is on the way to your locker';
      case OrderPreparationState.delivered:
        return 'Your order is waiting in your locker';
      case OrderPreparationState.pickedByCustomer:
        return 'Enjoy your meal!';
    }
  }
}
