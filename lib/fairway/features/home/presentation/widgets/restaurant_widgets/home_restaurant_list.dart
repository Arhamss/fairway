import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_filter_tabs.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/view/restaurant_tag_pages/discount_restaurants.dart';
import 'package:fairway/fairway/features/restaurant/presentation/view/restaurant_tag_pages/drinks_restaurants.dart';
import 'package:fairway/fairway/features/restaurant/presentation/view/restaurant_tag_pages/express_restaurants.dart';
import 'package:fairway/fairway/features/restaurant/presentation/view/restaurant_tag_pages/nearby_restaurants.dart';

class HomeRestaurantList extends StatefulWidget {
  const HomeRestaurantList({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<HomeRestaurantList> createState() => _HomeRestaurantListState();
}

class _HomeRestaurantListState extends State<HomeRestaurantList> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantCubit>().getNearbyRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RestaurantFilterTabs(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<RestaurantCubit, RestaurantState>(
              buildWhen: (previous, current) =>
                  previous.selectedFilter != current.selectedFilter,
              builder: (context, state) {
                final tag = state.selectedFilter;

                switch (tag) {
                  case RestaurantTag.nearby:
                    return const NearbyRestaurants();
                  case RestaurantTag.discounts:
                    return const DiscountRestaurants();
                  case RestaurantTag.express:
                    return const ExpressRestaurants();
                  case RestaurantTag.drinks:
                    return const DrinksRestaurants();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
