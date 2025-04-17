import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_history/order_history_response_data.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.repository}) : super(const OrderState());

  final OrderRepository repository;
  final Map<String, IO.Socket> _sockets = {};

  void _initializeSocketsForActiveOrders() {
    for (final socket in _sockets.values) {
      socket.disconnect();
      socket.dispose();
    }
    _sockets.clear();

    final activeOrders = state.activeOrders!;

    for (final orderData in activeOrders) {
      _initSocketForOrder(
        orderData.customer.userId,
        orderData.id,
        orderData,
      );
    }
  }

  bool _isOrderActive(String status) {
    final activeStatuses = ['preparing', 'delivered', 'enroute'];
    return activeStatuses.contains(status.toLowerCase());
  }

  void _initSocketForOrder(
    String userId,
    String orderId,
    OrderModel orderData,
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

      _initSocketForOrder(userId, orderId, orderData);
    });

    _sockets[orderId] = socket;
  }

  void handleOrderUpdate(String orderId, dynamic data) {
    try {
      final currentOrders = state.activeOrders;
      final orderIndex = currentOrders!.indexWhere(
        (order) => order.id == orderId,
      );

      if (orderIndex != -1) {
        final updatedOrder = currentOrders[orderIndex];
        currentOrders[orderIndex] = data as OrderModel;

        // 3. Update active orders in state
        emit(state.copyWith(activeOrders: currentOrders));

        // 4. Set the updated order as the current response model
        emit(
          state.copyWith(
            orderResponseModel: DataState.loaded(data: updatedOrder),
          ),
        );

        AppLogger.info('Updated order $orderId with new data: $data');
      }
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
          orderResponseModel: DataState.loaded(data: response.data!.order),
        ),
      );

      final currentOrders = List<OrderModel>.from(state.activeOrders!)
        ..add(response.data!.order);
      emit(state.copyWith(activeOrders: currentOrders));

      if (state.orderHistoryModel.data != null) {
        final historyList =
            List<OrderModel>.from(state.orderHistoryModel.data!.orders)
              ..add(response.data!.order);
        emit(
          state.copyWith(
            orderHistoryModel: DataState.loaded(
              data: state.orderHistoryModel.data!.copyWith(orders: historyList),
            ),
          ),
        );
      }

      _initSocketForOrder(
        response.data!.order.customer.userId,
        response.data!.order.id,
        response.data!.order,
      );
    } else {
      emit(
        state.copyWith(
          orderResponseModel: DataState.failure(error: response.message),
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

    final currentOrders = state.activeOrders!
        .where((orderState) => orderState.id != orderId)
        .toList();

    emit(state.copyWith(activeOrders: currentOrders));

    AppLogger.info('Order $orderId removed from active orders.');
  }

  @override
  Future<void> close() {
    for (final socket in _sockets.values) {
      socket.disconnect();
      socket.dispose();
    }
    _sockets.clear();
    return super.close();
  }

  void selectOrderMethod(OrderMethod method) {
    emit(state.copyWith(selectedOrderMethod: method));
  }

  void clearOrderMethod() {
    emit(state.copyWith());
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
          orderHistoryModel: DataState.loaded(data: response.data),
        ),
      );

      emit(
        state.copyWith(
          activeOrders: response.data!.orders
              .where((order) => _isOrderActive(order.status))
              .toList(),
        ),
      );

      _initializeSocketsForActiveOrders();
    } else {
      emit(
        state.copyWith(
          orderHistoryModel: DataState.failure(error: response.message),
        ),
      );
    }
  }

  void setCurrentTab(int index) {
    emit(state.copyWith(currentTab: index));
  }
}
