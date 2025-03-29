import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/chips.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    required this.text,
    this.buttonOneOnTap,
    this.buttonOneText,
    this.buttonTwoOnTap,
    this.buttonTwoText,
    this.showBorder = true,
    this.imagePath,
    this.buttonOnePrefixIcon,
    this.buttonTwoPrefixIcon,
    this.buttonOnePadding,
    this.buttonTwoPadding,
    this.buttonOneIsLoading = false,
    super.key,
  });

  final String text;
  final VoidCallback? buttonOneOnTap;
  final String? buttonOneText;
  final VoidCallback? buttonTwoOnTap;
  final String? buttonTwoText;
  final bool showBorder;
  final String? imagePath;
  final Widget? buttonOnePrefixIcon;
  final Widget? buttonTwoPrefixIcon;
  final EdgeInsets? buttonOnePadding;
  final EdgeInsets? buttonTwoPadding;
  final bool buttonOneIsLoading;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: showBorder
              ? Border.all(
                  color: AppColors.textFieldBorder,
                )
              : null,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              imagePath ?? AssetPaths.informationIcon,
              width: 72,
            ),
            Text(
              text,
              style: context.b3.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonOneText != null || buttonTwoText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (buttonOneText != null)
                      FairwayChip.secondary(
                        prefixIcon: buttonOnePrefixIcon,
                        text: buttonOneText ?? '',
                        textStyle: context.b3.copyWith(
                          color: AppColors.greenSecondary,
                        ),
                        padding: buttonOnePadding,
                        onTap: buttonOneOnTap,
                        isLoading: buttonOneIsLoading,
                      ),
                    if (buttonTwoText != null) ...[
                      const SizedBox(
                        width: 24,
                      ),
                      FairwayChip.secondary(
                        prefixIcon: buttonTwoPrefixIcon,
                        text: buttonTwoText ?? '',
                        textStyle: context.b3.copyWith(
                          color: AppColors.greenSecondary,
                        ),
                        onTap: buttonTwoOnTap,
                        padding: buttonTwoPadding,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
