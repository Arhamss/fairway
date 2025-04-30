import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    required this.activeOrders,
    this.onMarkAsCollected,
    super.key,
  });

  final NotificationModel notification;
  final List<OrderModel> activeOrders;
  final Function(String)? onMarkAsCollected;

  bool get _isDeliveredOrder =>
      notification.event == OrderPreparationState.delivered.toName;

  bool get _isInActiveOrders {
    if (!_isDeliveredOrder || notification.data == null) return false;

    final orderId = notification.data['orderId'] as String?;
    if (orderId == null) return false;

    return activeOrders.any((order) => order.id == orderId);
  }

  String? get _orderId => notification.data?['orderId'] as String?;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    notification.event ==
                                OrderPreparationState.delivered.toName ||
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
        ),
        if (_isDeliveredOrder && _isInActiveOrders && _orderId != null)
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 64),
            child: GestureDetector(
              onTap: () {
                if (onMarkAsCollected != null) {
                  onMarkAsCollected!(_orderId!);
                }
              },
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return Container(
                    height: 24,
                    width: 102,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.activeTabColor,
                      borderRadius: BorderRadius.circular(8),
                      
                    ),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state.collectionStatus.isLoading ? LoadingWidget(): 
                     const Text(
                      'Yes, Picked',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                      ],
                    ),
                    
                  );
                },
              ),
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
