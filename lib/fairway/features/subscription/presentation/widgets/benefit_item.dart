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
      children: [
        SvgPicture.asset(
          AssetPaths.checkMarkBulletIcon,
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
