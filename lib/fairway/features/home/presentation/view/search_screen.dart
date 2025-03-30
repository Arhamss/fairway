import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/search_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: FairwaySearchField(
          controller: _searchController,
          hintText: 'Search restaurants...',
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<HomeCubit>().searchRestaurants(query);
            }
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final isLoading = state.searchResults?.isLoading ?? false;
          final hasError = state.searchResults?.isFailure ?? false;
          final restaurants =
              state.searchResults?.data?.data?.restaurants ?? [];

          if (_searchController.text.isEmpty) {
            return _buildRecentSearches(context, state.recentSearches);
          }

          if (isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (hasError) {
            return Center(
              child: Text(
                state.searchResults?.errorMessage ?? 'No results found',
                style: context.b2.copyWith(color: AppColors.error),
              ),
            );
          }

          if (restaurants.isEmpty) {
            return const Center(
              child: Text('No search results found'),
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
                onTap: () => context.read<HomeCubit>().clearRecentSearches(),
                child: Text(
                  'CLEAR ALL',
                  style: context.b2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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
                  context.read<HomeCubit>().searchRestaurants(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantTile(BuildContext context, Restaurant restaurant) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: restaurant.images.isNotEmpty
            ? Image.network(
                restaurant.images.first,
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
