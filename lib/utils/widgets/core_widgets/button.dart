import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class FairwayButton extends StatelessWidget {
  const FairwayButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    super.key,
    this.backgroundColor = AppColors.amberPrimary,
    this.textColor = AppColors.black,
    this.disabledTextColor = AppColors.disabled,
    this.disabledBorderColor = AppColors.disabled,
    this.disabledBackgroundColor = AppColors.greenChipColor,
    this.borderRadius = 100,
    this.padding = const EdgeInsets.symmetric(vertical: 12.5, horizontal: 16),
    this.fontWeight = FontWeight.w500,
    this.borderColor = AppColors.primaryButton,
    this.splashColor = Colors.black12,
    this.fontSize = 16,
    this.prefixIcon,
    this.suffixIcon,
    this.outsidePadding = const EdgeInsets.all(4),
    this.isExpanded = true,
    this.iconSpacing,
    this.disabled = false,
    this.loadingColor = AppColors.black,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final FontWeight fontWeight;
  final Color borderColor;
  final Color splashColor;
  final double fontSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? outsidePadding;
  final bool isExpanded;
  final double? iconSpacing;
  final bool disabled;
  final Color disabledTextColor;
  final Color disabledBorderColor;
  final Color disabledBackgroundColor;
  final Color loadingColor;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: (isLoading || disabled) ? null : onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        backgroundColor: disabled ? disabledBackgroundColor : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: disabled ? disabledBorderColor : borderColor),
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: splashColor,
      ),
      child: Padding(
        padding: padding,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: LoadingWidget(),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    SizedBox(width: iconSpacing ?? 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.urbanist(
                      color: disabled ? disabledTextColor : textColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    SizedBox(width: iconSpacing ?? 8),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );

    return Padding(
      padding: outsidePadding ?? EdgeInsets.zero,
      child: isExpanded
          ? Row(
              children: [
                Expanded(child: button),
              ],
            )
          : button,
    );
  }
}
