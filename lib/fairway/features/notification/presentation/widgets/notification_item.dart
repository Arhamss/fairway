import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.goNamed(AppRouteNames.orderHistory);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.greyShade5,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                color: _getIconColor(),
                notification.event == OrderPreparationState.delivered.toName ||
                        notification.event ==
                            OrderPreparationState.pickedByCustomer.toName
                    ? AssetPaths.checkMarkIcon
                    : AssetPaths.notificationIcon,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification.body,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormatter.getTimeAgo(notification.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (notification.event) {
      case 'delivered':
        return Icons.check_circle;
      case 'preparing':
      case 'pickedByConcierge':
        return Icons.notifications;
      case 'pickedByCustomer':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

 

  Color _getIconColor() {
    switch (notification.event) {
      case 'delivered':
        return AppColors.greenPrimary;
      case 'preparing':
      case 'pickedByConcierge':
        return AppColors.primaryAmber;
      case 'pickedByCustomer':
        return AppColors.greenPrimary;
      default:
        return AppColors.primaryAmber;
    }
  }
}

class DateFormatter {
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
