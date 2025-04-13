import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.repository}) : super(const OrderState());

  final OrderRepository repository;

  // void createOrder() {
  //   emit(OrderCreating());
  //   // Simulate order creation process
  //   Future.delayed(Duration(seconds: 2), () {
  //     emit(OrderCreated());
  //   });
  // }

  void selectOrderMethod(OrderMethod method) {
    emit(
      state.copyWith(
        selectedOrderMethod: method,
      ),
    );
  }

  void clearOrderMethod() {
    emit(state.copyWith());
  }
}
