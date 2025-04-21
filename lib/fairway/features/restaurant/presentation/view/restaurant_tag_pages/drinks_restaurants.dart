import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card_shimmer.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/paginated_list_view.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class DrinksRestaurants extends StatelessWidget {
  const DrinksRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        final restaurants = state.drinksRestaurants.data?.restaurants ?? [];

        if (state.drinksRestaurants.isLoading && state.drinksCurrentPage == 1) {
          return Column(
            children: List.generate(
              3,
              (_) => const RestaurantCardShimmer(),
            ),
          );
        }

        if (state.drinksRestaurants.isFailure && state.drinksCurrentPage == 1) {
          return RetryWidget(
            onRetry: () => context.read<RestaurantCubit>().getDrinksRestaurants(
                  page: state.drinksCurrentPage,
                  sortBy: state.selectedSortOption,
                ),
            message: state.drinksRestaurants.errorMessage ??
                'Failed to load drink places',
          );
        }

        return PaginatedListView<RestaurantModel>(
          items: restaurants,
          itemBuilder: (context, restaurant, index) =>
              RestaurantCard(restaurant: restaurant),
          onLoadMore: () =>
              context.read<RestaurantCubit>().getDrinksRestaurants(
                    page: state.drinksCurrentPage + 1,
                    sortBy: state.selectedSortOption,
                    showLoading: false,
                  ),
          isLoadingMore: state.drinksRestaurants.isPageLoading,
          hasMore: state.drinksCurrentPage <
              (state.drinksRestaurants.data?.totalPages ?? 0),
        );
      },
    );
  }
}
