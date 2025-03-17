import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/chips.dart';

class FairwayTitleRowWidget extends StatelessWidget {
  const FairwayTitleRowWidget({
    required this.titleText,
    this.onTap,
    this.buttonText = 'View All',
    this.showButton = true,
    super.key,
  });

  final String titleText;
  final String buttonText;
  final VoidCallback? onTap;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: context.b1.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (showButton)
                FairwayChip.secondary(
                  text: buttonText,
                  textStyle: context.b3.copyWith(
                    color: AppColors.greenSecondary,
                  ),
                  onTap: onTap,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
