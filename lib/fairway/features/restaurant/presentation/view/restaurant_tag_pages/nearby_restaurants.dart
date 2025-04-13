import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card_shimmer.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/paginated_list_view.dart'; // <- import your custom widget
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class NearbyRestaurants extends StatelessWidget {
  const NearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        final restaurants = state.nearbyRestaurants.data?.restaurants ?? [];

        if (state.nearbyRestaurants.isLoading && state.nearbyCurrentPage == 1) {
          return Column(
            children: List.generate(
              3,
              (_) => const RestaurantCardShimmer(),
            ),
          );
        }

        if (state.nearbyRestaurants.isFailure && state.nearbyCurrentPage == 1) {
          return RetryWidget(
            onRetry: () => context.read<RestaurantCubit>().getNearbyRestaurant(
                  sortBy: state.selectedSortOption,
                  page: state.nearbyCurrentPage,
                ),
            message: state.nearbyRestaurants.errorMessage ??
                'Failed to load restaurants',
          );
        }

        return PaginatedListView<RestaurantModel>(
          
          items: restaurants,
          itemBuilder: (context, restaurant, index) {
            return RestaurantCard(restaurant: restaurant);
          },
          onLoadMore: () => context.read<RestaurantCubit>().getNearbyRestaurant(
                page: state.nearbyCurrentPage + 1,
                sortBy: state.selectedSortOption,
                showLoading: false,
              ),
          isLoadingMore: state.nearbyRestaurants.isPageLoading,
          hasMore: state.nearbyCurrentPage <
              (state.nearbyRestaurants.data?.totalPages ?? 0),
        );
      },
    );
  }
}
