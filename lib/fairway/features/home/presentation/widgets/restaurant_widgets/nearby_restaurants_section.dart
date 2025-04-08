import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class NearbyRestaurantsSection extends StatefulWidget {
  const NearbyRestaurantsSection({super.key});

  @override
  State<NearbyRestaurantsSection> createState() =>
      _NearbyRestaurantsSectionState();
}

class _NearbyRestaurantsSectionState extends State<NearbyRestaurantsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantCubit>().getRestaurants();
    });

    // Add scroll listener to detect when to load more
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
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.selectedFilter != current.selectedFilter,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterTab(context, 'Nearby', state),
                    _buildFilterTab(context, 'Sales', state),
                    _buildFilterTab(context, 'Rate', state),
                    _buildFilterTab(context, 'Fast', state),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Wrap the content with BlocBuilder too
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.selectedFilter != current.selectedFilter,
            builder: (context, state) {
              if (state.selectedFilter == 'Nearby') {
                return _buildNearbyRestaurants(context);
              } else if (state.selectedFilter == 'Sales') {
                return _buildEmptySection('Sales');
              } else if (state.selectedFilter == 'Rate') {
                return _buildEmptySection('Rate');
              } else {
                return _buildEmptySection('Fast');
              }
            },
          ),
        ],
      ),
    );
  }

  // Update _buildFilterTab to accept state parameter
  Widget _buildFilterTab(BuildContext context, String label, HomeState state) {
    final isSelected = state.selectedFilter == label;

    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().setSelectedFilter(label);

        // Reset pagination when filter changes
        if (label == 'Nearby') {
          context.read<RestaurantCubit>().resetNearbyPagination();
          context.read<RestaurantCubit>().getRestaurants();
        }
      },
      child: Column(
        children: [
          Text(
            label,
            style: context.b1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isSelected ? AppColors.secondaryBlue : AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (isSelected)
            Container(
              height: 2,
              width: 80,
              color: AppColors.black,
            ),
        ],
      ),
    );
  }

  // Build nearby restaurants section with pagination
  Widget _buildNearbyRestaurants(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        final isLoading =
            state.restaurants.isLoading && state.nearbyCurrentPage == 1;
        final hasError =
            state.restaurants.isFailure && state.nearbyCurrentPage == 1;
        final restaurants = state.restaurants.data?.restaurants ?? [];

        if (isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: LoadingWidget()),
          );
        }

        if (hasError) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                state.restaurants.errorMessage ?? 'Failed to load restaurants',
                style: context.b2.copyWith(color: AppColors.error),
              ),
            ),
          );
        }

        if (restaurants.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text('No nearby restaurants available'),
            ),
          );
        }

        // Replace the SizedBox with a Container that handles padding better
        return Container(
          // Use constraints instead of fixed height
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          // Add bottom padding to prevent overlay
          padding: const EdgeInsets.only(bottom: 8),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: restaurants.length + (state.isLoadingMoreNearby ? 1 : 0),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero, // Remove default ListView padding
            itemBuilder: (context, index) {
              if (index == restaurants.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: LoadingWidget()),
                );
              }
              return _buildRestaurantTile(context, restaurants[index]);
            },
          ),
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
    // Your existing _buildRestaurantTile code
    return InkWell(
      onTap: () => UrlHelper.launchWebsite(restaurant.website),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: restaurant.images.isNotEmpty
                  ? Image.network(
                      restaurant.images,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.greyShade2,
                          child: const Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 40,
                              color: AppColors.greyShade5,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 180,
                      color: AppColors.greyShade2,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 40,
                          color: AppColors.greyShade5,
                        ),
                      ),
                    ),
            ),

            // Restaurant details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: context.b1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: restaurant.categories.map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyShade5,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category.name,
                          style: context.l3.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Open',
                    style: context.b3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
