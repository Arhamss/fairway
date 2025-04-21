import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: context.b2.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: const BorderSide(color: AppColors.primaryBlue),
              foregroundColor: AppColors.primaryBlue,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              'Retry',
              style: context.b2.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
