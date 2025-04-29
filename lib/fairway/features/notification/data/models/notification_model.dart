import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.user,
    required this.title,
    required this.body,
    required this.event,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      user: json['user'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      event: json['event'] as String,
      data: json['data'] as Map<String, dynamic>,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String user;
  final String title;
  final String body;
  final String event;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'title': title,
      'body': body,
      'event': event,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? user,
    String? title,
    String? body,
    String? event,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      body: body ?? this.body,
      event: event ?? this.event,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        title,
        body,
        event,
        data,
        isRead,
        createdAt,
      ];
}