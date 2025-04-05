import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/models/saved_location_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';

class UserData extends Equatable {
  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.phone,
    this.savedLocations = const [],
    this.passwordResetToken,
    this.passwordResetExpires,
    this.subscriber = false,
    this.subscriptionStart,
    this.subscriptionEnd,
    this.blacklistedTokens = const [],
    this.notificationPreference = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    try {
      final userData = json['user'] as Map<String, dynamic>?;

      if (userData == null) {
        AppLogger.error(
            'UserData.fromJson: Missing "user" key in JSON. Full input: $json');
        throw Exception('User data is null');
      }

      return UserData(
        id: userData['id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        phone: userData['phone'] as String?,
        role: userData['role'] as String,
        savedLocations: (userData['savedLocations'] as List?)
                ?.map(
                  (loc) => SavedLocation.fromJson(loc as Map<String, dynamic>),
                )
                .toList() ??
            [],
        passwordResetToken: userData['passwordResetToken'] as String?,
        passwordResetExpires: userData['passwordResetExpires'] != null
            ? DateTime.parse(userData['passwordResetExpires'] as String)
            : null,
        createdAt: DateTime.parse(userData['createdAt'] as String),
        subscriber: userData['subscriber'] as bool? ?? false,
        subscriptionStart: userData['subscriptionStart'] != null
            ? DateTime.parse(userData['subscriptionStart'] as String)
            : null,
        subscriptionEnd: userData['subscriptionEnd'] != null
            ? DateTime.parse(userData['subscriptionEnd'] as String)
            : null,
        blacklistedTokens: (userData['blacklistedTokens'] as List?)
                ?.map((token) => token as String)
                .toList() ??
            [],
        notificationPreference:
            userData['notificationPreference'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'UserData.fromJson: Failed to parse user data.\n'
        'Error: $e\n'
        'Input: $json',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  static ResponseModel<BaseApiResponse<UserData>> parseResponse(
      Response response) {
    return ResponseModel.fromApiResponse<BaseApiResponse<UserData>>(
      response,
      (json) => BaseApiResponse<UserData>.fromJson(json, UserData.fromJson),
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final List<SavedLocation> savedLocations;
  final String? passwordResetToken;
  final DateTime? passwordResetExpires;
  final DateTime createdAt;
  final bool subscriber;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final List<String> blacklistedTokens;
  final bool notificationPreference;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'savedLocations': savedLocations.map((loc) => loc.toJson()).toList(),
        'passwordResetToken': passwordResetToken,
        'passwordResetExpires': passwordResetExpires?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'subscriber': subscriber,
        'subscriptionStart': subscriptionStart?.toIso8601String(),
        'subscriptionEnd': subscriptionEnd?.toIso8601String(),
        'blacklistedTokens': blacklistedTokens,
        'notificationPreference': notificationPreference,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        savedLocations,
        passwordResetToken,
        passwordResetExpires,
        createdAt,
        subscriber,
        subscriptionStart,
        subscriptionEnd,
        blacklistedTokens,
        notificationPreference,
      ];
}
