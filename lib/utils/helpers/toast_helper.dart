import 'package:fairway/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showErrorToast(String message) {
    toastification.show(
      description: Center(
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.topCenter,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.red,
        linearMinHeight: 1,
      ),
    );
  }

  static void showSuccessToast(String message) {
    toastification.show(
      description: Center(
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.topCenter,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearMinHeight: 1,
      ),
    );
  }

  static void showInfoToast(String message) {
    toastification.show(
      icon: const Icon(
        Icons.info_outline,
        color: AppColors.primary,
      ),
      description: Center(
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.topCenter,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearMinHeight: 1,
      ),
    );
  }

  static void showCustomToast(String message) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: const Text('Hello, World!'),
      description: RichText(
        text: const TextSpan(text: 'This is a sample toast message. '),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: const Icon(Icons.check),
      showIcon: true,
      // show or hide the icon
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
        ),
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
