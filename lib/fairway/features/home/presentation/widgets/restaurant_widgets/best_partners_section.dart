import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/best_partner_restaurant_card.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_text_button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class BestPartnersSection extends StatefulWidget {
  const BestPartnersSection({super.key});

  @override
  State<BestPartnersSection> createState() => _BestPartnersSectionState();
}

class _BestPartnersSectionState extends State<BestPartnersSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context.read<RestaurantCubit>().loadBestPartners();
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
      if (!state.isLoadingMoreBestPartners && state.hasMoreBestPartners) {
        context.read<RestaurantCubit>().loadMoreBestPartners();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Best Partners',
                  style: context.t2.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FairwayTextButton(
                  onPressed: () {
                    print('See all partners');
                  },
                  text: 'See All',
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.dividerColor,
            height: 1,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: BlocBuilder<RestaurantCubit, RestaurantState>(
              builder: (context, state) {
                final restaurants =
                    state.bestPartnerRestaurants.data?.restaurants ?? [];

                if (state.bestPartnerRestaurants.isLoading &&
                    state.bestPartnersCurrentPage == 1) {
                  return const Center(
                    child: SizedBox(
                      height: 150,
                      child: Center(
                        child: LoadingWidget(),
                      ),
                    ),
                  );
                }

                if (state.bestPartnerRestaurants.isFailure &&
                    state.bestPartnersCurrentPage == 1) {
                  return RetryWidget(
                    message: state.bestPartnerRestaurants.errorMessage ??
                        'An error occurred fetching features restaurants',
                    onRetry: () {
                      context.read<RestaurantCubit>().loadBestPartners();
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
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: restaurants.length +
                        (state.isLoadingMoreBestPartners ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == restaurants.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: LoadingWidget(),
                          ),
                        );
                      }
                      return BestPartnerRestaurantCard(
                        restaurant: restaurants[index],
                      );
                    },
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
