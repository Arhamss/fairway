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
}
