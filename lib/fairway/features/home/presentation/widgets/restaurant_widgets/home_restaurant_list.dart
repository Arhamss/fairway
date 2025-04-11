import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/nearby_restaurant_card.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/restaurant_filter_tab.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class HomeRestaurantList extends StatefulWidget {
  const HomeRestaurantList({super.key});

  @override
  State<HomeRestaurantList> createState() => _HomeRestaurantListState();
}

class _HomeRestaurantListState extends State<HomeRestaurantList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantCubit>().getRestaurants();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<RestaurantCubit>().state;
      if (!state.isLoadingMoreNearby && state.hasMoreNearbyRestaurants) {
        context.read<RestaurantCubit>().loadMoreRestaurants();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap the tab row with BlocBuilder
          BlocBuilder<RestaurantCubit, RestaurantState>(
            buildWhen: (previous, current) =>
                previous.selectedFilter != current.selectedFilter,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterTab(context, RestaurantTag.nearby),
                    _buildFilterTab(context, RestaurantTag.discounts),
                    _buildFilterTab(context, RestaurantTag.quickServe),
                    _buildFilterTab(context, RestaurantTag.drinks),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          BlocBuilder<RestaurantCubit, RestaurantState>(
            buildWhen: (previous, current) =>
                previous.selectedFilter != current.selectedFilter,
            builder: (context, state) {
              if (state.selectedFilter == RestaurantTag.nearby) {
                return _buildNearbyRestaurants(context);
              } else if (state.selectedFilter == RestaurantTag.discounts) {
                return _buildEmptySection(
                  RestaurantTag.discounts.toCapitalized(),
                );
              } else if (state.selectedFilter == RestaurantTag.quickServe) {
                return _buildEmptySection(
                  RestaurantTag.quickServe.toCapitalized(),
                );
              } else {
                return _buildEmptySection(RestaurantTag.drinks.toCapitalized());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(BuildContext context, RestaurantTag label) {
    final isSelected =
        context.read<RestaurantCubit>().state.selectedFilter == label;

    return RestaurantFilterTab(
      label: label.toCapitalized(),
      isSelected: isSelected,
      onTap: () {
        context.read<RestaurantCubit>().setSelectedFilter(label);
        if (label == RestaurantTag.nearby) {
          context.read<RestaurantCubit>().resetNearbyPagination();
          context.read<RestaurantCubit>().getRestaurants();
        }
      },
    );
  }

  Widget _buildNearbyRestaurants(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        final restaurants = state.restaurants.data?.restaurants ?? [];

        if (state.restaurants.isLoading && state.nearbyCurrentPage == 1) {
          return const Center(child: LoadingWidget());
        }

        if (state.restaurants.isFailure && state.nearbyCurrentPage == 1) {
          return Center(
            child: Text(
              state.restaurants.errorMessage ?? 'Failed to load restaurants',
              style: context.b2.copyWith(color: AppColors.error),
            ),
          );
        }

        return Column(
          children: [
            ...restaurants.map(
              (restaurant) => RestaurantCard(
                restaurant: restaurant,
              ),
            ),
            if (state.isLoadingMoreNearby)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: LoadingWidget()),
              ),
          ],
        );
      },
    );
  }

  // Build empty section for other filters
  Widget _buildEmptySection(String filterName) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          'No $filterName data available',
          style: context.b2.copyWith(color: AppColors.greyShade5),
        ),
      ),
    );
  }

  // Build restaurant tile
  Widget _buildRestaurantTile(
    BuildContext context,
    RestaurantModel restaurant,
  ) {
    return RestaurantCard(restaurant: restaurant);
  }
}
