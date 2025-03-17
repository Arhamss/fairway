import 'package:fairway/core/di/modules/app_modules.dart';
import 'package:get_it/get_it.dart';

abstract class Injector {
  static late final GetIt _container;

  static Future<void> setup() async {
    _container = GetIt.instance;
    await AppModule.setup(_container);
  }

  static T resolve<T extends Object>() => _container.get<T>();
}
