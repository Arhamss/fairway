import 'package:fairway/export.dart';

class FairwayChip extends StatelessWidget {
  const FairwayChip({
    required this.selected,
    required this.text,
    this.onTap,
    this.isLoading = false,
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textStyle,
    this.padding,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius,
    this.iconSpacing = 8,
  });

  const FairwayChip.secondary({
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    this.selected = false,
    this.backgroundColor = AppColors.greenDisabled,
    this.borderColor = AppColors.disabled,
    this.textColor = AppColors.greenPrimary,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius,
    this.iconSpacing = 0,
    super.key,
  });

  final String text;
  final bool selected;
  final bool isLoading;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? borderRadius;
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onTap,
      style: TextButton.styleFrom(
        splashFactory: InkRipple.splashFactory,
        overlayColor: Colors.black12,
        backgroundColor: backgroundColor ??
            (selected ? AppColors.greenDisabled : Colors.transparent),
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          side: BorderSide(
            color: borderColor ?? AppColors.disabled,
          ),
        ),
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 44),
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              ),
            )
          : Row(
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: iconSpacing),
                ],
                Text(
                  text,
                  style: textStyle ??
                      context.b1.copyWith(
                        color: textColor ??
                            (selected ? AppColors.black : AppColors.disabled),
                      ),
                ),
                if (suffixIcon != null) ...[
                  SizedBox(width: iconSpacing),
                  suffixIcon!,
                ],
              ],
            ),
    );
  }
}
