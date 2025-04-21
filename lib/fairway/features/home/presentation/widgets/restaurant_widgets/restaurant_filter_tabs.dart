import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/animated_tabs.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';

class RestaurantFilterTabs extends StatelessWidget {
  const RestaurantFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        const tags = RestaurantTag.values;
        final selectedIndex = tags.indexOf(state.selectedFilter);

        return AnimatedTabs(
          tabTitles: tags.map((tag) => tag.toCapitalized()).toList(),
          selectedIndex: selectedIndex,
          onTabChanged: (index) {
            final selectedTag = tags[index];
            final cubit = context.read<RestaurantCubit>()
              ..setSelectedFilter(selectedTag);

            switch (selectedTag) {
              case RestaurantTag.nearby:
                final nearbyData = state.nearbyRestaurants.data?.restaurants;
                if (nearbyData == null || nearbyData.isEmpty) {
                  cubit.getNearbyRestaurant();
                }

              case RestaurantTag.discounts:
                final discountData =
                    state.discountRestaurants.data?.restaurants;
                if (discountData == null || discountData.isEmpty) {
                  cubit.getDiscountRestaurants();
                }

              case RestaurantTag.express:
                final expressData = state.expressRestaurants.data?.restaurants;
                if (expressData == null || expressData.isEmpty) {
                  cubit.getExpressRestaurants();
                }

              case RestaurantTag.drinks:
                final drinksData = state.drinksRestaurants.data?.restaurants;
                if (drinksData == null || drinksData.isEmpty) {
                  cubit.getDrinksRestaurants();
                }
            }
          },
        );
      },
    );
  }
}
