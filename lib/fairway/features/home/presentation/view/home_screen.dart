import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/drawer/drawer.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/flight_alert_banner.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/home_header.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/best_partners_section.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/home_restaurant_list.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/presentation/view/order_confirmation_screen.dart';
import 'package:fairway/fairway/features/subscription/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final homeCubit = context.read<HomeCubit>();
    await homeCubit.loadUserProfile();
    final user = homeCubit.state.userProfile;
    final hasCurrentLocation =
        user.data?.savedLocations.any((location) => !location.isCurrent) ??
            false;

    if (!hasCurrentLocation) {
      context.goNamed(AppRouteNames.selectLocation);
    }

    await context.read<OrderCubit>().getOrderHistory();
    await context
        .read<SubscriptionCubit>()
        .getSubscriptionStatus(user.data!.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listenWhen: (previous, current) =>
          previous.orderResponseModel != current.orderResponseModel,
      listener: (context, state) {
        if (state.orderResponseModel.isLoaded) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const OrderConfirmationScreen(),
            isScrollControlled: true,
            isDismissible: false,
            backgroundColor: Colors.transparent,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkWhiteBackground,
        key: _scaffoldKey,
        drawer: const HomeDrawer(),
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

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeader(
                    userData: userData,
                    scaffoldKey: _scaffoldKey,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: FlightAlertNegativeBanner(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: BestPartnersSection(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const HomeRestaurantList(),
                      childCount: 1,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
