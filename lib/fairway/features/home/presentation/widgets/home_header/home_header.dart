import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/animated_tabs.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/home_header/category_item.dart';
import 'package:fairway/fairway/models/saved_location_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    this.userData,
    this.scaffoldKey,
  });

  final UserData? userData;
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
                              context.goNamed(AppRouteNames.searchScreen),
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
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SvgPicture.asset(
                          AssetPaths.notificationIcon,
                        ),
                      ),
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
                                context.pushNamed(AppRouteNames.userLocation);
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
                                  Row(
                                    children: [
                                      Text(
                                        (currentLocation
                                                    ?.airportName.isNotEmpty ??
                                                false)
                                            ? '${currentLocation!.airportName}, ${currentLocation.airportCode}'
                                            : 'Select location',
                                        style: context.b1.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Icon(
                                        Icons.arrow_right_rounded,
                                        color: AppColors.primaryAmber,
                                      ),
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Row(
                                      children: categories.map((category) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: CategoryItem(
                                            label: category['label']!,
                                            iconPath: category['icon']!,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (state.selectedTabIndex == 1) ...[
                              Column(
                                children: SortByOption.values.map((option) {
                                  final isSelected =
                                      state.selectedSortOption == option;

                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<HomeCubit>()
                                          .setSelectedSortOption(option);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16,
                                        left: 16,
                                        bottom: 8,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
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
                                                style: context.b2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textDark,
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
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 24),
                            FairwayButton(
                              outsidePadding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              borderRadius: 16,
                              text: 'Complete',
                              textColor: AppColors.white,
                              fontWeight: FontWeight.bold,
                              onPressed: () {
                                context
                                    .read<HomeCubit>()
                                    .setFilterExpanded(false);
                              },
                              isLoading: false,
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
