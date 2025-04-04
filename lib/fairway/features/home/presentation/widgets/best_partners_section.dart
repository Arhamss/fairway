import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class BestPartnersSection extends StatelessWidget {
  const BestPartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Best Partners',
              style: context.b1.copyWith(fontWeight: FontWeight.w800),
            ),
            TextButton(
              onPressed: () {
                // Handle "See all" action
              },
              child: Text(
                'See all',
                style: context.b2.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final restaurants =
                state.featuredRestaurants.data?.restaurants ?? [];

            if (state.featuredRestaurants.isLoading) {
              return const Center(
                child: SizedBox(
                  height: 150,
                  child: Center(child: LoadingWidget()),
                ),
              );
            }

            if (state.featuredRestaurants.isFailure) {
              return RetryWidget(
                message: state.featuredRestaurants.errorMessage ??
                    'An error occurred fetching features restaurants',
                onRetry: () {
                  context.read<HomeCubit>().loadFeaturedRestaurants();
                },
              );
            }

            if (restaurants.isEmpty) {
              return const SizedBox(
                height: 150,
                child: Center(
                  child: Text('No partners available'),
                ),
              );
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: restaurants.map((restaurant) {
                    return _buildRestaurantCard(context, restaurant);
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () => UrlHelper.launchWebsite(restaurant.website),
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: restaurant.images.isNotEmpty
                        ? Image.network(
                            restaurant.images.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const ColoredBox(
                                color: AppColors.greyShade2,
                                child: Center(
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 40,
                                    color: AppColors.greyShade5,
                                  ),
                                ),
                              );
                            },
                          )
                        : const ColoredBox(
                            color: AppColors.greyShade2,
                            child: Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 40,
                                color: AppColors.greyShade5,
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        textAlign: TextAlign.start,
                        style: context.b1.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Add a subtle website hint
                      Text(
                        'Tap to visit website',
                        style: context.l3.copyWith(
                          color: AppColors.greyShade5,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
