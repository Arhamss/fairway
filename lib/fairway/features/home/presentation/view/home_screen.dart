import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/best_partners_section.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/category_section.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/delivery_info_row.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/drawer.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/flight_alert_banner.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_app_bar.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/nearby_restaurants_section.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    await context.read<HomeCubit>().loadUserProfile();
    // Load restaurant data after profile is loaded
    await context.read<HomeCubit>().loadAllRestaurantsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhiteBackground,
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final isLoading = state.userProfile?.isLoading ?? false;
          final hasError = state.userProfile?.isFailure ?? false;
          final userData = state.userProfile?.data?.data;

          if (isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading profile',
                    style: context.b1.copyWith(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HomeCubit>().loadUserProfile(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Pass user data to DeliveryInfoRow
                  DeliveryInfoRow(userData: userData),
                  const SizedBox(height: 16),
                  const FlightAlertBanner(),
                  const SizedBox(height: 16),
                  const CategorySection(),
                  const SizedBox(height: 16),
                  const BestPartnersSection(),
                  const SizedBox(height: 16),
                  const NearbyRestaurantsSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
