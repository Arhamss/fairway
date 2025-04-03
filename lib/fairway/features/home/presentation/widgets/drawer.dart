import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ColoredBox(
            color: AppColors.drawerBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 30,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://placehold.co/600x400',
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.userProfile.data?.name ?? 'Daniel Jones',
                              style: context.b1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.userProfile.data?.email ??
                                  'example@email.com',
                              style: context.b1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerSectionHeader(title: 'General'),
                      DrawerTile(
                        icon: Icons.person_outline,
                        label: 'My Account',
                        onTap: () {
                          context.goNamed(
                            AppRouteNames.profileScreen,
                          );
                        },
                      ),
                      DrawerTile(
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Orders',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to orders
                        },
                      ),
                      DrawerTile(
                        icon: Icons.receipt_long_outlined,
                        label: 'Subscription',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to subscription
                        },
                      ),
                      DrawerTile(
                        icon: Icons.help_outline,
                        label: 'Help Center',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to help
                        },
                      ),
                      DrawerTile(
                        icon: Icons.description_outlined,
                        label: 'Terms of Service',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to terms
                        },
                      ),
                    ],
                  ),
                ),

                // App version at bottom
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Fairway v1.0.0',
                      style: context.l3.copyWith(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Reusable drawer section header
class DrawerSectionHeader extends StatelessWidget {
  const DrawerSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
      child: Text(
        title,
        style: context.t1.copyWith(
          color: AppColors.darkWhiteBackground,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}

// Reusable drawer tile widget
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.greyShade4
                .withValues(alpha: 0.2), // Changed to greyShade2
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: context.b1.copyWith(
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? AppColors.white,
                  ),
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: iconColor ?? AppColors.primaryBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
