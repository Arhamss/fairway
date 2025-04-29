import 'package:equatable/equatable.dart';
import 'package:fairway/export.dart';
import 'package:dio/dio.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class NotificationResponseData extends Equatable {
  const NotificationResponseData({
    required this.notifications,
    required this.totalResults,
    required this.totalPages,
    required this.currentPage,
    required this.unreadCount,
  });

  factory NotificationResponseData.fromJson(Map<String, dynamic> json) {
    return NotificationResponseData(
      notifications: (json['notifications'] as List)
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalResults: json['totalResults'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      unreadCount: json['unreadCount'] as int,
    );
  }

  final List<NotificationModel> notifications;
  final int totalResults;
  final int totalPages;
  final int currentPage;
  final int unreadCount;

  static ResponseModel<BaseApiResponse<NotificationResponseData>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<BaseApiResponse<NotificationResponseData>>(
      response,
      (json) => BaseApiResponse<NotificationResponseData>.fromJson(
        json,
        NotificationResponseData.fromJson,
      ),
    );
  }

  @override
  List<Object> get props => [
        notifications,
        totalResults,
        totalPages,
        currentPage,
        unreadCount,
      ];

  NotificationResponseData copyWith({
    List<NotificationModel>? notifications,
    int? totalResults,
    int? totalPages,
    int? currentPage,
    int? unreadCount,
  }) {
    return NotificationResponseData(
      notifications: notifications ?? this.notifications,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}