import 'package:fairway/export.dart';

class OrderSheetHeader extends StatelessWidget {
  const OrderSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
              image: DecorationImage(
                image: AssetImage(
                  AppConstants.placeholderUserAvatar,
                ), // Make sure to add this asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Role
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliff Rogers',
                style: context.h2.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Concierge',
                style: context.b2.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
