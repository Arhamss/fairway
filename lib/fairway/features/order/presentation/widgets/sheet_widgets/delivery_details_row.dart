import 'package:fairway/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveryDetailsRow extends StatelessWidget {
  const DeliveryDetailsRow({
    required this.label,
    required this.value,
    required this.svgPath,
    super.key,
    this.isCurrency = false,
  });

  final String label;
  final String value;
  final String svgPath;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: SvgPicture.asset(
                svgPath,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            // Label column
            SizedBox(
              width: 90,
              child: Text(
                label,
                maxLines: 2,
                style: context.b2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              child: Text(
                isCurrency ? '\$$value' : value,
                style: context.h3.copyWith(
                  color: AppColors.black,
                  fontSize: isCurrency ? 13 : 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
