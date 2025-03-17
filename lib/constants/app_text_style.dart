import 'package:fairway/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension AppTextStyle on BuildContext {
  TextStyle get h1 => GoogleFonts.urbanist(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  TextStyle get h2 => GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get h3 => GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  /// Title styles
  TextStyle get t1 => GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get t2 => GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  TextStyle get t3 => GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  /// Body styles
  TextStyle get b1 => GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  TextStyle get b2 => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  TextStyle get b3 => GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  /// Label styles
  TextStyle get l1 => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  TextStyle get l2 => GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  TextStyle get l3 => GoogleFonts.urbanist(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );
}

extension TextStyleModifiers on TextStyle {
  /// Font weight modifiers
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Color modifiers
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Predefined color modifier for secondary text
  TextStyle get secondary => copyWith(color: AppColors.textSecondary);

  // TextStyle get regular => copyWith(fontWeight: FontWeight.normal);

  /// Size modifiers
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// Letter spacing modifiers
  TextStyle withLetterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);

  /// Custom copyWith for multiple attributes
  TextStyle customCopyWith({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    double? letterSpacing,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return copyWith(
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      decoration: decoration ?? this.decoration,
      fontStyle: fontStyle ?? this.fontStyle,
    );
  }
}
