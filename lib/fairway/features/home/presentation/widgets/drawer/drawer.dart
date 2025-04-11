import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/drawer/drawer_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
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
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: AppConstants.placeholderUserAvatar,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.userProfile.data?.name ??
                                  AppConstants.placeholderUserName,
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
                                  AppConstants.placeholderUserEmail,
                              style: context.b2.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerTile(
                        assetPath: AssetPaths.myAccount,
                        label: 'My Account',
                        onTap: () {
                          context.goNamed(
                            AppRouteNames.profileScreen,
                          );
                        },
                      ),
                      DrawerTile(
                        assetPath: AssetPaths.myOrders,
                        label: 'My Orders',
                        onTap: () {},
                      ),
                      DrawerTile(
                        assetPath: AssetPaths.subscriptionDrawer,
                        label: 'Subscription',
                        onTap: () {},
                      ),
                      DrawerTile(
                        assetPath: AssetPaths.helpCenter,
                        label: 'Help Center',
                        onTap: () {},
                      ),
                      DrawerTile(
                        assetPath: AssetPaths.termsOfService,
                        label: 'Terms of Service',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version =
                            snapshot.hasData ? snapshot.data!.version : '...';
                        return Text(
                          'Fairway v$version',
                          style: context.l3.copyWith(color: Colors.white54),
                        );
                      },
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
