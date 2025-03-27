import 'package:fairway/go_router/exports.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/fairway/features/home/presentation/view/search_screen.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.black),
        onPressed: () {},
      ),
      title: FairwayTextField(
        onTap: () => context.goNamed(AppRouteNames.searchScreen),
        controller: TextEditingController(),
        hintText: 'Search',
        type: FairwayTextFieldType.location,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        readOnly: true, // Disable input to make it tappable
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: AppColors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
