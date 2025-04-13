import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/order_method.dart';

class OrderState extends Equatable {
  const OrderState({
    this.selectedOrderMethod,
  });

  final OrderMethod? selectedOrderMethod;

  OrderState copyWith({
    OrderMethod? selectedOrderMethod,
  }) {
    return OrderState(
      selectedOrderMethod: selectedOrderMethod ?? this.selectedOrderMethod,
    );
  }

  @override
  List<Object?> get props => [
        selectedOrderMethod,
      ];
}
