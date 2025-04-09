import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_search_field.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Load recent searches when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantCubit>().loadRecentSearches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      return;
    }

    // Debounce search to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<RestaurantCubit>().getSearchSuggestions(query);
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isEmpty) return;
    context.read<RestaurantCubit>().searchRestaurants(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: FairwaySmartSearchField(
          controller: _searchController,
          hintText: 'Search',
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          // Show recent searches when search field is empty
          if (_searchController.text.isEmpty) {
            return _buildRecentSearches(context, state.recentSearches);
          }

          // Show suggestions while typing
          if (state.searchSuggestions.isLoaded &&
              !state.searchResults.isLoading &&
              !state.searchResults.isLoaded) {
            return _buildSuggestions(context, state.searchSuggestions.data!);
          }

          // Show search results if search was submitted
          final isLoading = state.searchResults.isLoading;
          final hasError = state.searchResults.isFailure;
          final restaurants = state.searchResults.data?.restaurants ?? [];

          if (isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (hasError) {
            return Center(
              child: Text(
                state.searchResults.errorMessage ?? 'No results found',
                style: context.b2.copyWith(color: AppColors.error),
              ),
            );
          }

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
                    style: context.b1.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return _buildRestaurantTile(context, restaurant);
            },
          );
        },
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
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: suggestion.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: suggestion.images,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 56,
                      height: 56,
                      color: AppColors.greyShade5,
                      child: const Center(child: LoadingWidget(size: 20)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: AppColors.greyShade5,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.greyShade2,
                      ),
                    ),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: AppColors.greyShade5,
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.greyShade2,
                    ),
                  ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  suggestion.name,
                  style: context.b1.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suggestion.bestPartner)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.star,
                    size: 16,
                    color: AppColors.primaryAmber,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suggestion.categories.map((e) => e.name).join(', '),
                style: context.b3.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${suggestion.airport.name} (${suggestion.airport.code})',
                style: context.b3.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onTap: () {
            _searchController.text = suggestion.name;
            context
                .read<RestaurantCubit>()
                .searchRestaurants(_searchController.text);
          },
        );
      },
    );
  }

  Widget _buildRestaurantTile(
    BuildContext context,
    RestaurantModel restaurant,
  ) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: restaurant.images.isNotEmpty
            ? Image.network(
                restaurant.images,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: AppColors.greyShade2,
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 30,
                        color: AppColors.greyShade5,
                      ),
                    ),
                  );
                },
              )
            : Container(
                width: 50,
                height: 50,
                color: AppColors.greyShade2,
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 30,
                    color: AppColors.greyShade5,
                  ),
                ),
              ),
      ),
      title: Text(
        restaurant.name,
        style: context.b1.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        restaurant.categories.join(', '),
        style: context.l3.copyWith(color: AppColors.black),
      ),
      onTap: () => UrlHelper.launchWebsite(restaurant.website),
    );
  }
}
