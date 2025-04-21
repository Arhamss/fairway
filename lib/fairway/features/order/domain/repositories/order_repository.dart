import 'package:fairway/fairway/features/order/data/models/order_history/order_history_response_data.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class OrderRepository {
  Future<RepositoryResponse<OrderResponseData>> createOrder(String orderType);
  Future<RepositoryResponse<OrderHistoryResponseData>> getOrderHistory();
}
