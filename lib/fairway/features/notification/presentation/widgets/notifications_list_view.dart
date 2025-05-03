import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/features/notification/presentation/widgets/notification_item.dart';
import 'package:intl/intl.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({
    super.key,
    required this.notifications,
    required this.onLoadMore,
    required this.hasMoreData,
    this.isLoading = false,
  });

  final List<NotificationModel> notifications;
  final VoidCallback onLoadMore;
  final bool hasMoreData;
  final bool isLoading;

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !widget.isLoading &&
        widget.hasMoreData) {
      widget.onLoadMore();
    }
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate() {
    final groupedNotifications = <String, List<NotificationModel>>{};
    
    for (final notification in widget.notifications) {
      final date = _getFormattedDate(notification.createdAt);
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }
    
    return groupedNotifications;
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (DateUtils.isSameDay(date, now)) {
      return 'Today';
    } else if (DateUtils.isSameDay(date, yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotificationsByDate();
    final dates = groupedNotifications.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        return b.compareTo(a);
      });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dates.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= dates.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LoadingWidget(),
            ),
          );
        }

        final date = dates[index];
        final notifications = groupedNotifications[date]!;

        return BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {

                final inProgressOrders = state.orderHistoryModel.data?.orders.where((order) {
      final status = order.status.toLowerCase();
      return status == OrderPreparationState.delivered.toName;
    }).toList() ?? [];
            return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...notifications.map(
                      (notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NotificationItem(notification: notification, activeOrders: inProgressOrders,
                        onMarkAsCollected: (p0) => context.read<NotificationCubit>().markAsCollected(
                          p0,
                        ),
                      ),
                    ),
                    ),
                  ],
                );
          },
        );
      },
    );
  }
}