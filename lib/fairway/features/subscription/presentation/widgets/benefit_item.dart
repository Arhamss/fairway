import 'package:fairway/export.dart';

class BenefitItem extends StatelessWidget {
  const BenefitItem({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.greyShade4,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.check,
            color: AppColors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}
