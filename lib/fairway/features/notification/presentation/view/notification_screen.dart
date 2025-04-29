import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/notification/presentation/widgets/notification_item.dart';
import 'package:fairway/fairway/features/notification/presentation/widgets/notifications_list_view.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    context.read<NotificationCubit>().fetchNotifications(refresh: true);
    context.read<NotificationCubit>().markAsRead();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: AppColors.white,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.fetchNotifications.isLoading) {
            return const LoadingWidget();
          }

          if (state.notifications == null) {
            return RetryWidget(
              onRetry: () {
                context.read<NotificationCubit>().fetchNotifications();
              },
              message: state.fetchNotifications.errorMessage?? 'An error occurred while fetching notifications.',
            );
          }

          if (state.notifications.isEmpty && !state.fetchNotifications.isLoading) {
            return const EmptyStateWidget(image: AssetPaths.empty, text: 'No notifications available.',);
          }

          return NotificationListView(
              notifications: state.notifications,
              onLoadMore: context.read<NotificationCubit>().loadMore,
              hasMoreData: state.hasMorePages,
              isLoading: state.fetchNotifications.isLoading,
            );
        }
      ),
    );
  }
}
