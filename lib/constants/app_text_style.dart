import 'package:fairway/constants/app_colors.dart';
import 'package:flutter/material.dart';

extension AppTextStyle on BuildContext {
  TextStyle get h1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  TextStyle get h2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get h3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  /// Title styles
  TextStyle get t1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get t2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  TextStyle get t3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  /// Body styles
  TextStyle get b1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  TextStyle get b2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  TextStyle get b3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  /// Label styles
  TextStyle get l1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get l2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  TextStyle get l3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );
}

// TextStyleModifiers extension remains unchanged
