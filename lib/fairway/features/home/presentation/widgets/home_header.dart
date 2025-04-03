import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/animated_tabs.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    this.userData,
  });

  final UserData? userData;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            72,
            16,
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.black),
                    onPressed: () {},
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
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: AppColors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  Row(
                                    children: [
                                      Text(
                                        widget.userData?.location ??
                                            'Select location',
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
                                      )
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
                            horizontal: 16, vertical: 12),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Animated Expandable Section
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
                            AnimatedTabs(
                              selectedIndex: state.selectedTabIndex,
                              onTabChanged: (index) {
                                context
                                    .read<HomeCubit>()
                                    .setSelectedTabIndex(index);
                              },
                            ),
                            const SizedBox(height: 16),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _CategoryItem(
                                    label: 'Sandwich',
                                    iconPath: 'assets/icons/sandwich.png'),
                                _CategoryItem(
                                    label: 'Pizza',
                                    iconPath: 'assets/icons/pizza.png'),
                                _CategoryItem(
                                    label: 'Burgers',
                                    iconPath: 'assets/icons/burger.png'),
                              ],
                            ),
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

/// Category Item widget
class _CategoryItem extends StatelessWidget {
  final String label;
  final String iconPath;

  const _CategoryItem({required this.label, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.greyShade5,
          child: Image.asset(iconPath, height: 40),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.b2.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
