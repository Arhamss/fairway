import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/fairway/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImplementation implements OrderRepository {
  OrderRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? Injector.resolve<ApiService>(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<void> createOrder() async {
    throw UnimplementedError('createOrder() has not been implemented yet.');
  }
}
