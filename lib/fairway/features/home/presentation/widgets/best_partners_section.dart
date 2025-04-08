import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
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

    // Add scroll listener to detect when to load more
    _scrollController.addListener(_onScroll);

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadBestPartners();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if we're at the right edge of the horizontal list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<HomeCubit>().state;
      if (!state.isLoadingMoreBestPartners && state.hasMoreBestPartners) {
        context.read<HomeCubit>().loadMoreBestPartners();
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Partners',
                style: context.b1.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  // Handle "See all" action
                },
                child: Text(
                  'See all',
                  style: context.b2.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final restaurants =
                  state.bestPartnerRestaurants.data?.restaurants ?? [];

              if (state.bestPartnerRestaurants.isLoading &&
                  state.bestPartnersCurrentPage == 1) {
                return const Center(
                  child: SizedBox(
                    height: 150,
                    child: Center(child: LoadingWidget()),
                  ),
                );
              }

              if (state.bestPartnerRestaurants.isFailure &&
                  state.bestPartnersCurrentPage == 1) {
                return RetryWidget(
                  message: state.bestPartnerRestaurants.errorMessage ??
                      'An error occurred fetching features restaurants',
                  onRetry: () {
                    context.read<HomeCubit>().loadBestPartners();
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
                        child: Center(child: LoadingWidget()),
                      );
                    }
                    return _buildRestaurantCard(context, restaurants[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    RestaurantModel restaurant,
  ) {
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
                            restaurant.images,
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
