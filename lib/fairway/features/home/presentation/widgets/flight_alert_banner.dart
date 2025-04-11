import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlightAlertNegativeBanner extends StatelessWidget {
  const FlightAlertNegativeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetPaths.flightDelayedIcon,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Flight AI - 56 is delayed.',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SvgPicture.asset(
            AssetPaths.circleCrossIcon,
          ),
        ],
      ),
    );
  }
}
