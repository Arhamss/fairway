import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/notification/presentation/widgets/notifications_list_view.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    context.read<NotificationCubit>().fetchNotifications(refresh: true);
    context.read<OrderCubit>().getOrderHistory();
    context.read<NotificationCubit>().markAsRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
         if (state.collectionStatus.isLoaded)  {
            context.read<NotificationCubit>().resetcollectionStatus();
            context.goNamed(AppRouteNames.homeScreen);
          }
          else if (state.collectionStatus.isFailure) {
            context.read<NotificationCubit>().resetcollectionStatus();
            ToastHelper.showErrorToast(
              state.collectionStatus.errorMessage ??
                  'An error occurred while marking the order as collected.',
            );
          }
      },
      child: Scaffold(
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
          if (state.fetchNotifications.isLoading &&
              state.notifications.isEmpty) {
            return const LoadingWidget();
          }

          if (state.notifications == null) {
            return RetryWidget(
              onRetry: () {
                context.read<NotificationCubit>().fetchNotifications();
              },
              message: state.fetchNotifications.errorMessage ??
                  'An error occurred while fetching notifications.',
            );
          }

          if (state.notifications.isEmpty &&
              !state.fetchNotifications.isLoading) {
            return const EmptyStateWidget(
              image: AssetPaths.empty,
              text: 'No notifications available.',
            );
          }

          return NotificationListView(
            notifications: state.notifications,
            onLoadMore: context.read<NotificationCubit>().loadMore,
            hasMoreData: state.hasMorePages,
            isLoading: state.fetchNotifications.isLoading,
          );
        }),
      ),
    );
  }
}
