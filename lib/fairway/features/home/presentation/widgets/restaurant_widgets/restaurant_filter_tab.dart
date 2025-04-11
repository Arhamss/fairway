import 'package:fairway/export.dart';

class RestaurantFilterTab extends StatelessWidget {
  const RestaurantFilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: context.b1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isSelected ? AppColors.secondaryBlue : AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (isSelected)
            Container(
              height: 2,
              width: 80,
              color: AppColors.black,
            ),
        ],
      ),
    );
  }
}
