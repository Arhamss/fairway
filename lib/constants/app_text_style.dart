import 'package:fairway/constants/app_colors.dart';
import 'package:flutter/material.dart';

extension AppTextStyle on BuildContext {
  // Headlines
  TextStyle get h1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 32,
        fontWeight: FontWeight.w700, // bold
        color: AppColors.black,
      );

  TextStyle get h2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 28,
        fontWeight: FontWeight.w600, // semi
        color: AppColors.black,
      );

  TextStyle get h3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 24,
        fontWeight: FontWeight.w500, // medium
        color: AppColors.black,
      );

  // Titles
  TextStyle get t1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 20,
        fontWeight: FontWeight.w600, // semi
        color: AppColors.black,
      );

  TextStyle get t2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 18,
        fontWeight: FontWeight.w500, // medium
        color: AppColors.black,
      );

  TextStyle get t3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 16,
        fontWeight: FontWeight.w500, // medium
        color: AppColors.black,
      );

  // Body
  TextStyle get b1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 16,
        fontWeight: FontWeight.w400, // book
        color: AppColors.black,
      );

  TextStyle get b2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 14,
        fontWeight: FontWeight.w400, // book
        color: AppColors.black,
      );

  TextStyle get b3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 12,
        fontWeight: FontWeight.w400, // book
        color: AppColors.black,
      );

  // Labels
  TextStyle get l1 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 14,
        fontWeight: FontWeight.w600, // semi
        color: AppColors.black,
      );

  TextStyle get l2 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 12,
        fontWeight: FontWeight.w500, // medium
        color: AppColors.black,
      );

  TextStyle get l3 => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 10,
        fontWeight: FontWeight.w400, // book
        color: AppColors.black,
      );

  // Bonus - custom text styles using other weights

  TextStyle get thickText => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 18,
        fontWeight: FontWeight.w800, // thick
        color: AppColors.black,
      );

  TextStyle get lightText => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 18,
        fontWeight: FontWeight.w300, // lig
        color: AppColors.black,
      );

  TextStyle get extraLightText => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 18,
        fontWeight: FontWeight.w200, // xlig
        color: AppColors.black,
      );

  TextStyle get italicBody => const TextStyle(
        fontFamily: 'Gothic',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic, // bookoblique, semioblique, etc.
        color: AppColors.black,
      );
}
