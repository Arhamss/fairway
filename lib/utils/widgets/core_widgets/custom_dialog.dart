import 'dart:io';

import 'package:fairway/core/permissions/permission_manager.dart';
import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class CustomDialog {
  static void showOpenSettingsDialog({
    required BuildContext context,
    required String title,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: context.b1,
            textAlign: TextAlign.center,
          ),
          actions: [
            FairwayButton(
              text: 'Open Settings',
              onPressed: () async {
                await PermissionManager.openAppSettingsPage();
              },
              isLoading: false,
            ),
          ],
        );
      },
    );
  }

  static void showLoadingDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.7),
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: LoadingWidget(),
          ),
        );
      },
    );
  }

  static void showFullImage({
    required BuildContext context,
    required File imageFile,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.7),
      builder: (context) {
        return Stack(
          children: [
            Image.file(
              imageFile,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: context.pop,
                child: const Icon(
                  Icons.highlight_remove,
                  size: 45,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.7),
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: context.h2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: context.b1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            // Confirm Button
            FairwayButton(
              text: confirmText,
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                onConfirm(); // Execute the confirm action
              },
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              isLoading: false,
            ),
            const SizedBox(height: 8),
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                cancelText,
                style: context.b2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showActionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String cancelText = 'Cancel',
    bool isLoading = false,
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isLoading,
      barrierColor: AppColors.black.withOpacity(0.7),
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.white,
          title: Text(
            title,
            style: context.h2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          content: Text(
            message,
            style: context.b1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(24),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Confirm Button
                FairwayButton(
                  text: confirmText,
                  onPressed: isLoading ? null : onConfirm,
                  isLoading: isLoading,
                  backgroundColor:
                      isDanger ? AppColors.error : AppColors.primaryButton,
                  textColor: Colors.white,
                  borderRadius: 8,
                ),
                const SizedBox(height: 16),
                // Cancel Button
                FairwayButton(
                  text: cancelText,
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.textSecondary,
                  borderColor: AppColors.greyShade3,
                  borderRadius: 8,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
