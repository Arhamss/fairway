import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  const OrderState({
    this.isLoading = false,
  });

  final bool isLoading;

  OrderState copyWith({bool? isLoading}) {
    bool? isLoading;
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
      ];
}
