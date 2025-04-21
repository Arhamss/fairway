import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/features/notification/presentation/widgets/notification_item.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final todayNotifications = [
      NotificationModel(
        state: OrderPreparationState.delivered,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        state: OrderPreparationState.pickedByConcierge,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      NotificationModel(
        state: OrderPreparationState.preparing,
        time: DateTime.now().subtract(const Duration(minutes: 22)),
      ),
    ];

    final yesterdayNotifications = [
      NotificationModel(
        state: OrderPreparationState.pickedByCustomer,
        time: DateTime.now().subtract(const Duration(hours: 24, minutes: 30)),
      ),
    ];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Today Section
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...todayNotifications.map(
                (notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NotificationItem(notification: notification),
                ),
              ),

              const SizedBox(height: 16),
              // Yesterday Section
              const Text(
                'Yesterday',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...yesterdayNotifications.map(
                (notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NotificationItem(notification: notification),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
