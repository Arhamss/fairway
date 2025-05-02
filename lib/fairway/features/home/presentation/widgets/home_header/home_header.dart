import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/animated_tabs.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/category_item.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_text_button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    this.userData,
    this.scaffoldKey,
  });

  final UserModel? userData;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final currentLocation = widget.userData?.savedLocations
            .firstWhere((loc) => loc.isCurrent, orElse: SavedLocation.empty);
        return Container(
          padding: EdgeInsets.fromLTRB(
            0,
            72,
            0,
            state.isFilterExpanded ? 8 : 16,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          widget.scaffoldKey?.currentState?.openDrawer(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SvgPicture.asset(AssetPaths.menuIcon),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.greyShade5,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: FairwayTextField(
                          onTap: () =>
                              context.pushNamed(AppRouteNames.searchScreen),
                          controller: TextEditingController(),
                          hintText: 'Search',
                          type: FairwayTextFieldType.location,
                          readOnly: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(AssetPaths.notificationIcon),
                      onPressed: () {
                        context.pushNamed(AppRouteNames.notificationScreen);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AssetPaths.deliveryTo),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(AppRouteNames.selectLocation);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery to',
                                    style: context.b3.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (currentLocation?.airportName
                                                      .isNotEmpty ??
                                                  false)
                                              ? '${currentLocation!.airportName}, ${currentLocation.airportCode}'
                                              : 'Select location',
                                          style: context.b1.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          maxLines:
                                              state.isFilterExpanded ? 5 : 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_right_rounded,
                                        color: AppColors.primaryAmber,
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<HomeCubit>()
                            .setFilterExpanded(!state.isFilterExpanded);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.isFilterExpanded
                              ? AppColors.black
                              : AppColors.greyShade5,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetPaths.filterIcon),
                            const SizedBox(width: 8),
                            Text(
                              'Filter',
                              style: context.b2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: state.isFilterExpanded
                                    ? AppColors.white
                                    : AppColors.tertiaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: state.isFilterExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: AnimatedTabs(
                                tabTitles: const [
                                  'Restaurants',
                                  'Sort by',
                                  // 'Price',
                                ],
                                isHomeHeader: true,
                                selectedIndex: state.selectedTabIndex,
                                onTabChanged: (index) {
                                  context
                                      .read<HomeCubit>()
                                      .setSelectedTabIndex(index);
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (state.selectedTabIndex == 0) ...[
                              BlocBuilder<RestaurantCubit, RestaurantState>(
                                builder: (context, state) {
                                  if (state.categories.isLoading &&
                                      state.categories.data == null) {
                                    return const Center(
                                      child: LoadingWidget(),
                                    );
                                  }

                                  if (state.categories.isFailure) {
                                    return RetryWidget(
                                      message: state.categories.errorMessage ??
                                          'Failed to load categories',
                                      onRetry: () {
                                        context
                                            .read<RestaurantCubit>()
                                            .loadCategories();
                                      },
                                    );
                                  } else if (state.categories.data != null) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemCount:
                                            state.categories.data!.length,
                                        itemBuilder: (context, index) {
                                          final category =
                                              state.categories.data![index];
                                          return CategoryItem(
                                            isSelected:
                                                state.selectedCategoryIndex ==
                                                    index,
                                            label: category.name,
                                            iconPath: category.picture,
                                            onTap: () {
                                              context
                                                  .read<RestaurantCubit>()
                                                  .setSelectedCategoryIndex(
                                                    index,
                                                  );
                                              context
                                                  .read<RestaurantCubit>()
                                                  .setSelectedCategoryId(
                                                    category.id,
                                                  );
                                              AppLogger.info(
                                                'Selected category: ${category.id}',
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }

                                  return const LoadingWidget();
                                },
                              ),
                            ],
                            if (state.selectedTabIndex == 1) ...[
                              BlocBuilder<RestaurantCubit, RestaurantState>(
                                builder: (context, state) {
                                  return Column(
                                    children: SortByOption.values.map((option) {
                                      final isSelected =
                                          state.selectedSortOption == option;

                                      if (option == SortByOption.unselected) {
                                        return const SizedBox.shrink();
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<RestaurantCubit>()
                                                .setSelectedSortOption(option);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              left: 16,
                                              bottom: 8,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.greyShade5,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    option.asset,
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Text(
                                                      option.label,
                                                      style:
                                                          context.b2.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.textDark,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    SvgPicture.asset(
                                                      AssetPaths.selectedIcon,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 24),
                            BlocBuilder<RestaurantCubit, RestaurantState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    FairwayButton(
                                      outsidePadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      borderRadius: 16,
                                      text: 'Complete',
                                      textColor: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      onPressed: () async {
                                        context.goNamed(
                                          AppRouteNames.filteredRestaurants,
                                        );
                                        context
                                            .read<HomeCubit>()
                                            .setFilterExpanded(false);
                                      },
                                      isLoading:
                                          state.filteredRestaurants.isLoading,
                                    ),
                                    FairwayTextButton(
                                      text: 'Clear all',
                                      textStyle: context.b2.copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<RestaurantCubit>()
                                            .updateSelectedCategory(
                                              -1,
                                              '',
                                            );
                                        context
                                            .read<RestaurantCubit>()
                                            .updateSortOption(
                                              SortByOption.unselected,
                                            );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 6,
                              width: 42,
                              decoration: BoxDecoration(
                                color: AppColors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
