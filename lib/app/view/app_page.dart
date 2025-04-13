import 'package:fairway/app/view/app_view.dart';
import 'package:fairway/fairway/features/home/data/repositories/home_repository_implementation.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/location/data/repositories/location_repository_impl.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/data/repositories/onboarding_flow_repository_impl.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/data/repositories/order_repository_implementation.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/data/repositories/profile_repository_implementation.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/data/repository/restaurant_repository_impl.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FairwayTextFieldCubit(),
        ),
        BlocProvider(
          create: (context) => OnboardingFlowCubit(
            repository: OnboardingFlowRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => LocationCubit(
            repository: LocationRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => HomeCubit(
            repository: HomeRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => RestaurantCubit(
            repository: RestaurantRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            repository: ProfileRepositoryImplementation(),
          ),
        ),
        BlocProvider(
          create: (context) => OrderCubit(
            repository: OrderRepositoryImplementation(),
          ),
        ),
      ],
      child: const AppView(),
    );
  }
}
