import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_card/restaurant_card.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:fairway/utils/widgets/core_widgets/filter_tabs.dart';
import 'package:fairway/utils/widgets/core_widgets/paginated_list_view.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';
import 'package:flutter/material.dart';

class FilteredRestaurantsScreen extends StatefulWidget {
  const FilteredRestaurantsScreen({super.key});

  @override
  State<FilteredRestaurantsScreen> createState() =>
      _FilteredRestaurantsScreenState();
}

class _FilteredRestaurantsScreenState extends State<FilteredRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<RestaurantCubit>().getFilteredRestaurants(
          categoryIds:
              context.read<RestaurantCubit>().state.selectedCategoryIds,
          sortBy: context.read<RestaurantCubit>().state.selectedSortOption,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.white,
            forceMaterialTransparency: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            elevation: 0,
            title: const Text(
              'Restaurants',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: _buildBody(state, context),
        );
      },
    );
  }

  List<String> _getActiveFilters(RestaurantState state) {
    final filters = <String>[];

    // Get names for all selected category IDs
    if (state.selectedCategoryIds.isNotEmpty && state.categories.data != null) {
      for (final categoryId in state.selectedCategoryIds) {
        final category = state.categories.data!.firstWhere(
          (cat) => cat.id == categoryId,
        );
        filters.add(category.name);
      }
    }

    // Add sort option if selected
    if (state.selectedSortOption != SortByOption.unselected) {
      filters.add(state.selectedSortOption.label);
    }

    return filters;
  }

  void _handleFilterRemoval(String filter, BuildContext context) {
    final cubit = context.read<RestaurantCubit>();
    final state = cubit.state;

    if (filter == state.selectedSortOption.label) {
      cubit.updateSortOption(SortByOption.unselected);
      cubit.getFilteredRestaurants(
        categoryIds: state.selectedCategoryIds,
      );
    } else if (state.categories.data != null &&
        state.selectedCategoryIds.isNotEmpty) {
      final category = state.categories.data!.firstWhere(
        (category) => category.name == filter,
      );

      // Found matching category, remove its ID
      cubit.removeSelectedCategoryId(category.id);
      cubit.getFilteredRestaurants(
        sortBy: state.selectedSortOption,
      );
      return;
    }
  }

  Widget _buildBody(RestaurantState state, BuildContext context) {
    final activeFilters = _getActiveFilters(state);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activeFilters.isNotEmpty) ...[
              const SizedBox(height: 16),
              FairwayFilterTabsList(
                filters: activeFilters,
                onRemoveFilter: (filter) =>
                    _handleFilterRemoval(filter, context),
              ),
            ],
            Container(
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            Expanded(
              child: _buildRestaurantsList(state, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantsList(RestaurantState state, BuildContext context) {
    if (state.filteredRestaurants.isLoading &&
        (state.filteredRestaurants.data?.restaurants.isEmpty ?? true)) {
      return const LoadingWidget();
    }

    if (state.filteredRestaurants.isFailure) {
      return RetryWidget(
        onRetry: () {
          context.read<RestaurantCubit>().getFilteredRestaurants();
        },
        message: state.filteredRestaurants.errorMessage ??
            'An error occurred while fetching restaurants.',
      );
    }

    final restaurants = state.filteredRestaurants.data?.restaurants ?? [];

    if (restaurants.isEmpty && !state.filteredRestaurants.isLoading) {
      return const EmptyStateWidget(
        image: AssetPaths.empty,
        text: 'No restaurants available.',
      );
    }

    return PaginatedListView(
      items: restaurants,
      itemBuilder: (context, restaurant, index) => RestaurantCard(
        restaurant: restaurant,
      ),
      onLoadMore: () => context.read<RestaurantCubit>().getFilteredRestaurants(
            page: state.filteredRestaurantsCurrentPage + 1,
            categoryIds: state.selectedCategoryIds,
            sortBy: state.selectedSortOption,
          ),
      hasMore: state.filteredRestaurants.data!.totalPages >
          state.filteredRestaurants.data!.currentPage,
      isLoadingMore: state.filteredRestaurants.isLoading,
      padding: EdgeInsets.zero,
      separator: const SizedBox(height: 16),
    );
  }
}
