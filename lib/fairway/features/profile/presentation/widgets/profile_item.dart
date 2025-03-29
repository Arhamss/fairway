import 'package:fairway/export.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColors.greyShade4,
                size: 18,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: context.b1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: labelColor ?? AppColors.black,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: context.b1.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyShade1,
                        ),
                      ),
                  ],
                ),
              ),
              if (showArrow)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: iconColor ?? AppColors.greyShade3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
