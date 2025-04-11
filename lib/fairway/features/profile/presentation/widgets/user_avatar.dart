import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.imageUrl,
    super.key,
    this.size = 100.0,
    this.showEditIcon = false,
    this.onEditTap,
  });

  final String? imageUrl;
  final double size;
  final bool showEditIcon;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Image.asset(
                AppConstants.placeholderUserAvatar,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              AppConstants.placeholderUserAvatar,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showEditIcon)
          Positioned(
            top: 0,
            right: -6,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.drawerBackground,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    AssetPaths.editIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
