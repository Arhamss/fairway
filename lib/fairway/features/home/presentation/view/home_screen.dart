import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/best_partners_section.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/category_section.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/flight_alert_banner.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/nearby_restaurants_section.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

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
    final homeCubit = context.read<HomeCubit>();
    await homeCubit.loadUserProfile();
    final user = homeCubit.state.userProfile;
    if ((user.data?.location ?? '').isEmpty) {
      context.goNamed(AppRouteNames.selectLocation);
    }
    await homeCubit.loadAllRestaurantsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhiteBackground,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final userData = state.userProfile.data;

          if (state.userProfile.isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (state.userProfile.isFailure) {
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
            child: Column(
              children: [
                HomeHeader(userData: userData),

                /// Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 16),
                      FlightAlertBanner(),
                      SizedBox(height: 16),
                      CategorySection(),
                      SizedBox(height: 16),
                      BestPartnersSection(),
                      SizedBox(height: 16),
                      NearbyRestaurantsSection(),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
