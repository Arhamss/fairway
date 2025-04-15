import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.repository}) : super(const OrderState());

  final OrderRepository repository;
  IO.Socket? socket;

  void _initSocket(String userId, String orderId) {
    socket = IO.io(
      'https://fairways-backend.onrender.com/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('🟢 Connected to server with socket id: ${socket!.id}');

      socket!.emit('joinOrderRoom', {
        'userId': userId,
        'orderId': orderId,
      });
    });

    socket!.on('orderStatusUpdate', (data) {
      debugPrint('🔁 Order Status Update Received: $data');
      // You can emit a new state with the update if needed
      // emit(state.copyWith(orderStatus: data));
    });

    socket!.onDisconnect((_) {
      debugPrint('🔴 Disconnected from server');
    });
  }

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
      _initSocket(
          response.data?.order.user ?? '', response.data?.order.id ?? '');
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
