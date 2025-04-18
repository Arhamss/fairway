import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fairway/config/flavor_config.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/firebase_options_dev.dart' as dev;
import 'package:fairway/firebase_options_prod.dart' as prod;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  final flavor = FlavorConfig.instance.flavor;
  var name = 'fairway';
  FirebaseOptions firebaseOptions;
  switch (flavor) {
    case Flavor.production:
      firebaseOptions = prod.DefaultFirebaseOptions.currentPlatform;
      name = 'fairwayProd';
    case Flavor.development:
      firebaseOptions = dev.DefaultFirebaseOptions.currentPlatform;
      name = 'fairwayDev';

  }
  await Injector.setup();

  runApp(await builder());
}
