import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/recent_search_list.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/recent_search_tile.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/suggestion_tile.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/empty_state_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_search_field.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final RestaurantCubit _restaurantCubit;

  @override
  void initState() {
    super.initState();
    _restaurantCubit = context.read<RestaurantCubit>();
    _restaurantCubit.loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Instead of accessing context in dispose, use the cached cubit
    _restaurantCubit.resetSearchState();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isEmpty) return;
    _restaurantCubit
      ..getSearchSuggestions(query)
      ..searchRestaurants(query);
  }

  void _handleBackPress() {
    // Use the cached reference here too
    _restaurantCubit.resetSearchState();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                    ),
                    onPressed: _handleBackPress,
                  ),
                  Expanded(
                    child: FairwaySmartSearchField(
                      controller: _searchController,
                      hintText: 'Search',
                      onChanged:
                          context.read<RestaurantCubit>().onSearchTextChanged,
                      onSubmitted: _onSearchSubmitted,
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RestaurantCubit, RestaurantState>(
              builder: _buildSearchContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, RestaurantState state) {
    if (state.searchSuggestions.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (state.searchSuggestions.isLoaded) {
      return _buildSuggestions(context, state.searchSuggestions.data!);
    }

    if (state.searchSuggestions.isFailure) {
      return RetryWidget(
        message: state.searchSuggestions.errorMessage ?? 'Search failed',
        onRetry: () {
          context.read<RestaurantCubit>().getSearchSuggestions(
                _searchController.text,
              );
        },
      );
    }

    return _buildRecentSearches(
      context,
      state.recentSearchesData.data?.recentSearches ?? [],
    );
  }

  Widget _buildRecentSearches(
    BuildContext context,
    List<String> recentSearches,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: context.b1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () =>
                    context.read<RestaurantCubit>().clearRecentSearches(),
                child: Text(
                  'Clear All',
                  style: context.b2.copyWith(
                    color: AppColors.secondaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: recentSearches.isEmpty
              ? const EmptyStateWidget(
                  image: AssetPaths.empty,
                  text: 'No recent searches',
                  imageSize: 100,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RecentSearchList(
                    queries: recentSearches,
                    onTap: (query) {
                      _searchController.text = query;
                      _onSearchSubmitted(query);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, SearchSuggestionsModel data) {
    if (data.suggestions.isEmpty) {
      return const Center(
        child: Text('No suggestions found'),
      );
    }

    return ListView.separated(
      itemCount: data.suggestions.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final suggestion = data.suggestions[index];
        return SuggestionTile(
          suggestion: suggestion,
        );
      },
    );
  }
}
