import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/order/data/models/order_history/order_history_response_data.dart';
import 'package:fairway/fairway/features/order/data/models/order_response.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class OrderRepositoryImplementation implements OrderRepository {
  OrderRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? Injector.resolve<ApiService>(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<OrderResponseData>> createOrder(
    String orderType,
  ) async {
    try {
      final response = await _apiService.put(
        Endpoints.orderTypes,
        {'orderType': orderType},
      );

      final result = OrderResponseData.parseResponse(response);
      final orderResponse = result.response?.data;

      if (response.statusCode == 200 ||
          response.statusCode == 201 && orderResponse != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: orderResponse,
          message: 'Order created successfully',
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: 'Failed to create order',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'An error occurred while creating the order',
      );
    }
  }

  @override
  Future<RepositoryResponse<OrderHistoryResponseData>> getOrderHistory() async {
    try {
      final response = await _apiService.get(Endpoints.orderHistory);

      final result = OrderHistoryResponseData.parseResponse(response);
      final orderHistoryResponse = result.response?.data;

      if (response.statusCode == 200 && orderHistoryResponse != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: orderHistoryResponse,
          message: 'Order history retrieved successfully',
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: 'Failed to retrieve order history',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'An error occurred while retrieving the order history',
      );
    }
  }
}
