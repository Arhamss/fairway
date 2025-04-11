import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class FairwayButton extends StatelessWidget {
  const FairwayButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    super.key,
    this.backgroundColor = AppColors.primaryBlue,
    this.textColor = AppColors.black,
    this.disabledTextColor = AppColors.white,
    this.disabledBackgroundColor,
    this.borderRadius = 100,
    this.padding = const EdgeInsets.symmetric(vertical: 12.5, horizontal: 16),
    this.fontWeight = FontWeight.w500,
    this.splashColor = Colors.black12,
    this.fontSize = 16,
    this.prefixIcon,
    this.suffixIcon,
    this.outsidePadding = const EdgeInsets.all(4),
    this.isExpanded = true,
    this.iconSpacing,
    this.disabled = false,
    this.loadingColor = AppColors.black,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final FontWeight fontWeight;
  final Color splashColor;
  final double fontSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? outsidePadding;
  final bool isExpanded;
  final double? iconSpacing;
  final bool disabled;
  final Color disabledTextColor;
  final Color? disabledBackgroundColor;
  final Color loadingColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    // Use provided disabled background color or derive from background color
    final effectiveDisabledBackgroundColor =
        disabledBackgroundColor ?? backgroundColor.withOpacity(0.5);

    final button = TextButton(
      onPressed: (isLoading || disabled) ? null : onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        backgroundColor:
            disabled ? effectiveDisabledBackgroundColor : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(
                  color:
                      disabled ? borderColor!.withOpacity(0.5) : borderColor!,
                  width: borderWidth,
                )
              : BorderSide.none,
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: splashColor,
      ),
      child: Padding(
        padding: padding,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: LoadingWidget(
                  color: textColor,
                ),
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
