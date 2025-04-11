import 'package:fairway/export.dart';

class RecentSearchTile extends StatelessWidget {
  const RecentSearchTile({
    required this.query,
    required this.onTap,
    super.key,
  });

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20), // Adjusted border radius
          border: Border.all(
            color: AppColors.greyShade3,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ), // Adjusted padding
        child: Text(
          query,
          style: context.b2.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
