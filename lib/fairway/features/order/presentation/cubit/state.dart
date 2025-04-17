import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/fairway/features/order/data/models/order_history/order_history_response_data.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class OrderState extends Equatable {
  const OrderState({
    this.selectedOrderMethod,
    this.orderResponseModel = const DataState.initial(),
    this.activeOrders = const [],
    this.orderHistoryModel = const DataState.initial(),
    this.currentTab = 0,
  });

  final OrderMethod? selectedOrderMethod;
  final DataState<OrderModel> orderResponseModel;
  final List<OrderModel>? activeOrders;
  final DataState<OrderHistoryResponseData> orderHistoryModel;
  final int currentTab;

  OrderState copyWith({
    OrderMethod? selectedOrderMethod,
    DataState<OrderModel>? orderResponseModel,
    List<OrderModel>? activeOrders,
    DataState<OrderHistoryResponseData>? orderHistoryModel,
    int? currentTab,
  }) {
    return OrderState(
      selectedOrderMethod: selectedOrderMethod ?? this.selectedOrderMethod,
      orderResponseModel: orderResponseModel ?? this.orderResponseModel,
      activeOrders: activeOrders ?? this.activeOrders,
      orderHistoryModel: orderHistoryModel ?? this.orderHistoryModel,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  @override
  List<Object?> get props => [
        selectedOrderMethod,
        orderResponseModel,
        activeOrders,
        orderHistoryModel,
        currentTab,
      ];
}
