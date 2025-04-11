import 'package:fairway/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ProfileItemType {
  normal,
  notification,
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.iconPath,
    required this.title,
    this.subtitle,
    this.type = ProfileItemType.normal,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
    super.key,
  });

  final String iconPath; // Path to the SVG icon
  final String title; // Title of the tile
  final String? subtitle; // Optional subtitle
  final ProfileItemType type; // Type of the tile (normal or notification)
  final bool? switchValue; // Value of the switch (only for notification type)
  final ValueChanged<bool>? onSwitchChanged; // Callback for switch changes
  final VoidCallback? onTap; // Callback for tile tap

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: type == ProfileItemType.normal ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Prefix SVG Icon
              SvgPicture.asset(
                iconPath,
              ),
              const SizedBox(width: 16),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.b1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: context.b2.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
              ),

              // Trailing Widget based on type
              if (type == ProfileItemType.notification)
                Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    activeColor: AppColors.black,
                    inactiveTrackColor: AppColors.greyShade5,
                    activeTrackColor: AppColors.black.withOpacity(0.6),
                    thumbColor: MaterialStateProperty.all(AppColors.white),
                    value: switchValue ?? false,
                    onChanged: onSwitchChanged,
                  ),
                )
              else if (type == ProfileItemType.normal)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.greyShade4,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
