import 'package:fairway/export.dart';

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
    this.enableDivider = true,
    super.key,
  });

  final String iconPath;
  final String title;
  final String? subtitle;
  final ProfileItemType type;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final bool enableDivider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: type == ProfileItemType.normal ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 18,
                  ),
                  const SizedBox(width: 24),
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
                  if (type == ProfileItemType.notification)
                    Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        // activeColor: AppColors.black,
                        // inactiveTrackColor: AppColors.greyShade5,
                        activeTrackColor: AppColors.drawerBackground,
                        thumbColor: WidgetStateProperty.all(AppColors.white),
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
            if (enableDivider)
              const Divider(
                color: AppColors.greyShade5,
                height: 1,
              )
          ],
        ),
      ),
    );
  }
}
