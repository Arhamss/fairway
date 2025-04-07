import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends Equatable {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      final userData = json['user'] as Map<String, dynamic>?;

      if (userData == null) {
        AppLogger.error(
          'UserData.fromJson: Missing "user" key in JSON. Full input: $json',
        );
        throw Exception('User data is null');
      }

      return UserModel(
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

  static ResponseModel<BaseApiResponse<UserModel>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<BaseApiResponse<UserModel>>(
      response,
      (json) => BaseApiResponse<UserModel>.fromJson(json, UserModel.fromJson),
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final List<SavedLocation> savedLocations;

  @HiveField(6)
  final String? passwordResetToken;

  @HiveField(7)
  final DateTime? passwordResetExpires;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final bool subscriber;

  @HiveField(10)
  final DateTime? subscriptionStart;

  @HiveField(11)
  final DateTime? subscriptionEnd;

  @HiveField(12)
  final List<String> blacklistedTokens;

  @HiveField(13)
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

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    List<SavedLocation>? savedLocations,
    String? passwordResetToken,
    DateTime? passwordResetExpires,
    DateTime? createdAt,
    bool? subscriber,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    List<String>? blacklistedTokens,
    bool? notificationPreference,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      savedLocations: savedLocations ?? this.savedLocations,
      passwordResetToken: passwordResetToken ?? this.passwordResetToken,
      passwordResetExpires: passwordResetExpires ?? this.passwordResetExpires,
      createdAt: createdAt ?? this.createdAt,
      subscriber: subscriber ?? this.subscriber,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      blacklistedTokens: blacklistedTokens ?? this.blacklistedTokens,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
    );
  }

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
