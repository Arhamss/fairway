import 'package:fairway/export.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
    required this.isRead,
    super.key,
  });

  final String? icon;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.iconBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.04,
          vertical: MediaQuery.sizeOf(context).height * 0.01,
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.amberPrimary,
                      width: 0.75,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon ?? AssetPaths.notificationEnabledIcon,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                if (!isRead)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.amberPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: context.b1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: context.b2.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  time,
                  style: context.l3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textNormal,
                  ),
                ),
                const SizedBox(height: 24),
                SvgPicture.asset(
                  AssetPaths.rightArrowIcon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
