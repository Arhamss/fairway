import 'package:fairway/app/view/app_page.dart';
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

  void handleOrderUpdate(String orderId, dynamic rawData) {
    try {
      emit(
        state.copyWith(
          isNew: const DataState.loading(),
        ),
      );
      final orderData = rawData?['data']?['order'] as Map<String, dynamic>?;

      if (orderData == null) {
        AppLogger.error('Invalid order data structure received');
        return;
      }

      final currentOrders = List<OrderModel>.from(state.activeOrders ?? []);
      final orderIndex = currentOrders.indexWhere(
        (order) => order.id == orderId,
      );

      if (orderIndex != -1) {
        final currentOrder = currentOrders[orderIndex];

        AppLogger.info(
          'Updating order $orderId with new status: ${orderData['status']}',
        );
        final updatedOrder = currentOrder.copyWith(
          status: orderData['status'] as String? ?? currentOrder.status,
          estimatedTime:
              orderData['estimatedTime'] as int? ?? currentOrder.estimatedTime,
        );

        currentOrders[orderIndex] = updatedOrder;

        emit(state.copyWith(activeOrders: currentOrders));
        emit(
          state.copyWith(
            orderResponseModel: DataState.loaded(data: updatedOrder),
            isNew: const DataState.loaded(data: false),
          ),
        );

        AppLogger.info('Updated order $orderId with new data: $orderData');
      }
    } catch (e, s) {
      AppLogger.error('Error updating order: $e', e, s);
    }
  }

  Future<void> placeOrder() async {
    emit(
      state.copyWith(
        orderResponseModel: const DataState.loading(),
        isNew: const DataState.loading(),
      ),
    );

    final response = await repository.createOrder(
      state.selectedOrderMethod?.toName ?? OrderMethod.pickYourself.toName,
    );

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          orderResponseModel: DataState.loaded(data: response.data!.order),
          isNew: const DataState.loaded(data: true),
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
