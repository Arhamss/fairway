import 'package:fairway/export.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.assetPath,
    required this.label,
    required this.onTap,
    super.key,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
  });

  final String assetPath;
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
            color: AppColors.drawerTileBackground.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                assetPath,
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
                SvgPicture.asset(
                  AssetPaths.rightArrowRounded,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
