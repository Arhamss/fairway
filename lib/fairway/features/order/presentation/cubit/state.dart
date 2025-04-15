import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/fairway/features/order/data/models/order_history/order_history_response_data.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class OrderState extends Equatable {
  const OrderState({
    this.selectedOrderMethod,
    this.activeOrders = const [],
    this.orderResponseModel = const DataState.initial(),
    this.orderHistoryModel = const DataState.initial(),
    this.currentTab = 0,
  });

  final OrderMethod? selectedOrderMethod;
  final List<OrderResponseData> activeOrders;
  final DataState<OrderResponseData> orderResponseModel;
  final DataState<OrderHistoryResponseData> orderHistoryModel;
  final int currentTab;

  OrderState copyWith({
    OrderMethod? selectedOrderMethod,
    List<OrderResponseData>? activeOrders,
    DataState<OrderResponseData>? orderResponseModel,
    DataState<OrderHistoryResponseData>? orderHistoryModel,
    int? currentTab,
  }) {
    return OrderState(
      selectedOrderMethod: selectedOrderMethod ?? this.selectedOrderMethod,
      activeOrders: activeOrders ?? this.activeOrders,
      
      orderResponseModel: orderResponseModel ?? this.orderResponseModel,
      orderHistoryModel: orderHistoryModel ?? this.orderHistoryModel,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  @override
  List<Object?> get props => [
        selectedOrderMethod,
        activeOrders,
        orderResponseModel,
        orderHistoryModel,
        currentTab,
      ];
}
