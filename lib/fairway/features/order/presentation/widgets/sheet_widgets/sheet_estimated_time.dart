import 'package:fairway/export.dart';

class EstimatedTime extends StatelessWidget {
  const EstimatedTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: AppColors.greyShade7,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Estimated Time',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Text(
            '30mins',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
