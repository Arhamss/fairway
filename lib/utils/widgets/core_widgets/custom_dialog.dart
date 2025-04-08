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
        return Dialog(
          // Remove SingleChildScrollView and ConstrainedBox - they're causing the issue
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important: use min size
              children: [
                Text(
                  title,
                  style: context.h2.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  message,
                  style: context.b1.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 32),
                // Replace Column with Row and remove Expanded widgets
                Flexible(
                  child: FairwayButton(
                    text: confirmText,
                    onPressed: isLoading ? null : onConfirm,
                    isLoading: isLoading,
                    backgroundColor:
                        isDanger ? AppColors.error : AppColors.primaryBlue,
                    textColor: AppColors.white,
                    borderRadius: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Flexible(
                    child: Text(
                      cancelText,
                      style: context.b2.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
