import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_search_tile.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/suggestion_tile.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<RestaurantCubit>().loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isEmpty) return;
    context.read<RestaurantCubit>().searchRestaurants(query);
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
                    onPressed: () => context.pop(),
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
              builder: (context, state) {
                if (state.isIdle && _searchController.text.isEmpty) {
                  return _buildRecentSearches(context, state.recentSearches);
                }

                if (state.searchSuggestions.isLoading &&
                    !state.searchResults.isLoading &&
                    !state.searchResults.isLoaded) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }

                if (state.searchSuggestions.isLoaded &&
                    !state.searchResults.isLoading &&
                    !state.searchResults.isLoaded) {
                  return _buildSuggestions(
                      context, state.searchSuggestions.data!);
                }

                if (state.searchResults.isFailure ||
                    state.searchSuggestions.isFailure) {
                  return RetryWidget(
                    message: state.searchResults.errorMessage ??
                        state.searchSuggestions.errorMessage ??
                        'No results found',
                    onRetry: () {
                      context.read<RestaurantCubit>().searchRestaurants(
                            _searchController.text,
                          );
                    },
                  );
                }

                final restaurants = state.searchResults.data?.restaurants ?? [];

                if (restaurants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 60,
                          color: AppColors.greyShade3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No restaurants found for "${_searchController.text}"',
                          style: context.b1
                              .copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    return RestaurantSearchTile(
                      restaurant: restaurants[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT SEARCHES',
                style: context.b2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<RestaurantCubit>().clearRecentSearches(),
                child: Text(
                  'CLEAR ALL',
                  style: context.b2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final query = recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.search, color: AppColors.greyShade2),
                title: Text(
                  query,
                  style: context.b1.copyWith(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  _searchController.text = query;
                  context.read<RestaurantCubit>().searchRestaurants(query);
                },
              );
            },
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
          onTap: () {
            _searchController.text = suggestion.name;
            context.read<RestaurantCubit>().searchRestaurants(suggestion.name);
          },
        );
      },
    );
  }
}
