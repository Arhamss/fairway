import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/presentation/view/order_confirmation_screen.dart';
import 'package:fairway/fairway/features/order/presentation/view/order_details_sheet.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.repository}) : super(const OrderState());

  final OrderRepository repository;
  final Map<String, IO.Socket> _sockets = {};

  void _initSocketForOrder(
    String userId,
    String orderId,
    OrderResponseData orderData,
  ) {
    if (_sockets.containsKey(orderId)) return;

    final socket = IO.io(
      'https://fairways-backend.onrender.com/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint(
        '🟢 Connected to server with socket id: ${socket.id} for order: $orderId',
      );
      socket.emit('joinOrderRoom', {
        'userId': userId,
        'orderId': orderId,
      });
    });

    socket.on('orderStatusUpdate', (data) {
      AppLogger.info('🔄 Status Update for order $orderId: $data');
      if (data != null) {
        handleOrderUpdate(orderId, data);
      }
    });

    socket.onDisconnect((_) {
      debugPrint('🔴 Disconnected from server for order: $orderId');
    });

    _sockets[orderId] = socket;
  }

  void handleOrderUpdate(String orderId, dynamic data) {
    try {
      emit(
        state.copyWith(
          orderResponseModel: const DataState.loading(),
        ),
      );
      final currentOrders = state.activeOrders;
      final orderIndex = currentOrders.indexWhere(
        (order) => order.order.id == orderId,
      );

      if (orderIndex == -1) {
        AppLogger.error('Order with ID $orderId not found in active orders.');
        return;
      }

      // Create a new order object with updated fields
      final currentOrder = currentOrders[orderIndex];
      final updatedOrder = currentOrder.copyWith(
        order: currentOrder.order.copyWith(
          estimatedTime:
              data['estimatedTime'] as int? ?? currentOrder.order.estimatedTime,
          status: data['status'] as String? ?? currentOrder.order.status,
        ),
      );

      currentOrders[orderIndex] = updatedOrder;

      emit(
        state.copyWith(
          orderResponseModel: DataState.loaded(data: updatedOrder),
        ),
      );

      AppLogger.info('Updated order $orderId with new data: $data');
    } catch (e) {
      AppLogger.error('Error updating order: $e');
    }
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

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          orderResponseModel: DataState.loaded(
            data: response.data,
          ),
        ),
      );
      final currentOrders = List<OrderResponseData>.from(state.activeOrders)
        ..add(response.data!);

      emit(state.copyWith(activeOrders: currentOrders));

      _initSocketForOrder(
        response.data!.order.user,
        response.data!.order.id,
        response.data!,
      );
    } else {
      emit(
        state.copyWith(
          orderResponseModel: DataState.failure(
            error: response.message,
          ),
        ),
      );
      AppLogger.error('Error placing order: ${response.message}');
    }
  }

  void removeOrder(String orderId) {
    // Clean up socket
    _sockets[orderId]?.disconnect();
    _sockets[orderId]?.dispose();
    _sockets.remove(orderId);

    // Remove from active orders
    final currentOrders = state.activeOrders
        .where((orderState) => orderState.order.id != orderId)
        .toList();

    emit(state.copyWith(activeOrders: currentOrders));
  }

  @override
  Future<void> close() {
    // Clean up all sockets when cubit is closed
    for (final socket in _sockets.values) {
      socket.disconnect();
      socket.dispose();
    }
    _sockets.clear();
    return super.close();
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
