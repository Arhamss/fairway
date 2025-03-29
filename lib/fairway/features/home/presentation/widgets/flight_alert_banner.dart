import 'package:flutter/material.dart';
import 'package:fairway/constants/app_colors.dart';

class FlightAlertBanner extends StatelessWidget {
  const FlightAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: AppColors.error),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Flight AI - 56 is delayed.',
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
