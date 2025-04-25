import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:intl/intl.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.state,
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      state: OrderPreparationState.fromName(json['state'] as String),
      time: DateTime.parse(json['time'] as String),
    );
  }

  final OrderPreparationState state;
  final DateTime time;

  Map<String, dynamic> toJson() {
    return {
      'state': state.toName,
      'time': time.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    OrderPreparationState? state,
    DateTime? time,
  }) {
    return NotificationModel(
      state: state ?? this.state,
      time: time ?? this.time,
    );
  }

  String get title {
    switch (state) {
      case OrderPreparationState.preparing:
        return 'Order in progress';
      case OrderPreparationState.pickedByConcierge:
        return 'Order picked up from restaurant';
      case OrderPreparationState.delivered:
        return 'Order Received?';
      case OrderPreparationState.pickedByCustomer:
        return 'Order completed';
    }
  }

  String get description {
    switch (state) {
      case OrderPreparationState.preparing:
        return 'Your order is being prepared—hang tight.';
      case OrderPreparationState.pickedByConcierge:
        return 'Your order is on its way— Fresh and fast.';
      case OrderPreparationState.delivered:
        return 'Your order is securely placed in the locker—pick it up at your convenience.';
      case OrderPreparationState.pickedByCustomer:
        return 'Enjoy your meal! Hope to see you again soon.';
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return DateFormat('h:mm a').format(time);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [state, time];
}
