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
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              color: _getIconColor(),
              notification.state == OrderPreparationState.delivered ||
                      notification.state ==
                          OrderPreparationState.pickedByCustomer
                  ? AssetPaths.checkMarkIcon
                  : AssetPaths.notificationIcon,
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
                notification.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification.formattedTime,
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
    switch (notification.state) {
      case OrderPreparationState.delivered:
        return Icons.check_circle;
      case OrderPreparationState.preparing:
      case OrderPreparationState.pickedByConcierge:
        return Icons.notifications;
      case OrderPreparationState.pickedByCustomer:
        return Icons.check_circle;
    }
  }

  Color _getIconBackgroundColor() {
    switch (notification.state) {
      case OrderPreparationState.delivered:
        return AppColors.greyShade5;
      case OrderPreparationState.preparing:
      case OrderPreparationState.pickedByConcierge:
        return AppColors.greyShade5;
      case OrderPreparationState.pickedByCustomer:
        return AppColors.greyShade5;
    }
  }

  Color _getIconColor() {
    switch (notification.state) {
      case OrderPreparationState.delivered:
        return AppColors.greenPrimary;
      case OrderPreparationState.preparing:
      case OrderPreparationState.pickedByConcierge:
        return AppColors.primaryAmber;
      case OrderPreparationState.pickedByCustomer:
        return AppColors.greenPrimary;
    }
  }
}
