import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class NearbyRestaurantsSection extends StatefulWidget {
  const NearbyRestaurantsSection({super.key});

  @override
  State<NearbyRestaurantsSection> createState() =>
      _NearbyRestaurantsSectionState();
}

class _NearbyRestaurantsSectionState extends State<NearbyRestaurantsSection> {
  String selectedFilter = 'Nearby';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter options as tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilterTab(context, 'Nearby'),
              _buildFilterTab(context, 'Sales'),
              _buildFilterTab(context, 'Rate'),
              _buildFilterTab(context, 'Fast'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Display content based on selected filter
        if (selectedFilter == 'Nearby') _buildNearbyRestaurants(context),
        if (selectedFilter == 'Sales') _buildEmptySection('Sales'),
        if (selectedFilter == 'Rate') _buildEmptySection('Rate'),
        if (selectedFilter == 'Fast') _buildEmptySection('Fast'),
      ],
    );
  }

  // Build filter tab
  Widget _buildFilterTab(BuildContext context, String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
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

  // Build nearby restaurants section
  Widget _buildNearbyRestaurants(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state.nearbyRestaurants.isLoading;
        final hasError = state.nearbyRestaurants.isFailure;
        final restaurants = state.nearbyRestaurants.data?.restaurants ?? [];

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
                state.nearbyRestaurants.errorMessage ??
                    'Failed to load restaurants',
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

        return Column(
          children: restaurants.map((restaurant) {
            return _buildRestaurantTile(context, restaurant);
          }).toList(),
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
  Widget _buildRestaurantTile(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () => UrlHelper.launchWebsite(restaurant.website),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                      restaurant.images.first,
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
                  // Name and status row
                  Text(
                    restaurant.name,
                    style: context.b1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Categories as tags
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
                          category,
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
