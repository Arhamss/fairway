import 'package:fairway/app/view/app_view.dart';
import 'package:fairway/fairway/features/home/data/repositories/home_repository_implementation.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/data/repositories/onboardingflow_repository_implementation.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
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
            repository: OnboardingFlowRepositoryImplementation(),
          ),
        ),
        BlocProvider(
          create: (context) => HomeCubit(
            repository: HomeRepositoryImplementation(),
          ),
        ),
      ],
      child: const AppView(),
    );
  }
}
