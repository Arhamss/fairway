import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/best_partner_restaurant_card.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/best_partner_shimmer_card.dart';
import 'package:fairway/utils/widgets/core_widgets/empty_state_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_text_button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/paginated_list_view.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class BestPartnersSection extends StatelessWidget {
  const BestPartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Best Partners',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FairwayTextButton(
                  onPressed: () {
                    context.read<RestaurantCubit>().loadBestPartners();
                  },
                  text: 'See all',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: BlocBuilder<RestaurantCubit, RestaurantState>(
              builder: (context, state) {
                if (state.bestPartnerRestaurants.isLoading &&
                    state.bestPartnersCurrentPage == 1) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3, // Show 3 shimmer cards
                      itemBuilder: (context, index) {
                        return const BestPartnerShimmerCard();
                      },
                    ),
                  );
                }

                if (state.bestPartnerRestaurants.isFailure &&
                    state.bestPartnersCurrentPage == 1) {
                  return RetryWidget(
                    message: state.bestPartnerRestaurants.errorMessage ??
                        'Failed to load restaurants',
                    onRetry: () =>
                        context.read<RestaurantCubit>().loadBestPartners(),
                  );
                }

                final restaurants =
                    state.bestPartnerRestaurants.data?.restaurants ?? [];

                if (restaurants.isEmpty) {
                  return const EmptyStateWidget(
                    image: 'assets/images/empty_state.svg',
                    text: 'No partners available',
                    spacing: 16,
                    imageSize: 80,
                  );
                }

                return Expanded(
                  child: PaginatedListView<RestaurantModel>(
                    items: restaurants,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemBuilder: (context, restaurant, index) {
                      return BestPartnerRestaurantCard(
                        restaurant: restaurant,
                      );
                    },
                    onLoadMore: () =>
                        context.read<RestaurantCubit>().loadMoreBestPartners(),
                    isLoadingMore: state.bestPartnerRestaurants.isPageLoading,
                    hasMore: state.bestPartnersCurrentPage <
                        (state.bestPartnerRestaurants.data?.totalPages ?? 0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
