import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';

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
    emit(
      state.copyWith(),
    );
  }

  Future<void> placeOrder() async {
    emit(
      state.copyWith(
        orderResponseModel: const DataState.loading(),
      ),
    );

    final response = await repository.createOrder(
      state.selectedOrderMethod?.toName ?? OrderMethod.pickYourself.toName,
    );

    if (response.isSuccess) {
      emit(
        state.copyWith(
          orderResponseModel: DataState.loaded(
            data: response.data,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          orderResponseModel: DataState.failure(
            error: response.message,
          ),
        ),
      );
    }
  }

  Future<void> getOrderHistory() async {
    emit(
      state.copyWith(
        orderHistoryModel: const DataState.loading(),
      ),
    );

    final response = await repository.getOrderHistory();

    if (response.isSuccess) {
      emit(
        state.copyWith(
          orderHistoryModel: DataState.loaded(
            data: response.data,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          orderHistoryModel: DataState.failure(
            error: response.message,
          ),
        ),
      );
    }
  }

  void setCurrentTab(int index) {
    emit(
      state.copyWith(
        currentTab: index,
      ),
    );
  }
}
