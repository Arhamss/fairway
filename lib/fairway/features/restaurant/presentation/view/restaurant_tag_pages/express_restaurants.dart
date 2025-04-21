import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_card_shimmer.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/paginated_list_view.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class ExpressRestaurants extends StatelessWidget {
  const ExpressRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        final restaurants = state.expressRestaurants.data?.restaurants ?? [];

        if (state.expressRestaurants.isLoading &&
            state.expressCurrentPage == 1) {
          return Column(
            children: List.generate(
              3,
              (_) => const RestaurantCardShimmer(),
            ),
          );
        }

        if (state.expressRestaurants.isFailure &&
            state.expressCurrentPage == 1) {
          return RetryWidget(
            onRetry: () =>
                context.read<RestaurantCubit>().getExpressRestaurants(
                      page: state.expressCurrentPage,
                      sortBy: state.selectedSortOption,
                    ),
            message: state.expressRestaurants.errorMessage ??
                'Failed to load express restaurants',
          );
        }

        return PaginatedListView<RestaurantModel>(
          items: restaurants,
          itemBuilder: (context, restaurant, index) =>
              RestaurantCard(restaurant: restaurant),
          onLoadMore: () =>
              context.read<RestaurantCubit>().getExpressRestaurants(
                    page: state.expressCurrentPage + 1,
                    sortBy: state.selectedSortOption,
                    showLoading: false,
                  ),
          isLoadingMore: state.expressRestaurants.isPageLoading,
          hasMore: state.expressCurrentPage <
              (state.expressRestaurants.data?.totalPages ?? 0),
        );
      },
    );
  }
}
