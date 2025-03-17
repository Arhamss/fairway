import 'package:fairway/export.dart';

class FairwayIconButton extends StatelessWidget {
  const FairwayIconButton({
    this.icon,
    this.onPressed,
    this.backgroundColor = AppColors.iconBackground,
    this.iconColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.borderColor = Colors.transparent,
    this.iconSize = 24.0,
    this.splashColor = Colors.black12,
    this.outsidePadding = const EdgeInsetsDirectional.all(8),
    this.iconPadding,
    super.key,
  });

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? iconColor;
  final BorderRadiusGeometry borderRadius;
  final Color borderColor;
  final double iconSize;
  final Color splashColor;
  final Widget? icon;
  final double? iconPadding;
  final EdgeInsetsDirectional outsidePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outsidePadding,
      child: IconButton(
        onPressed: onPressed ?? () => context.pop(),
        icon: icon ??
            SvgPicture.asset(
              AssetPaths.leftArrowIcon,
            ),
        color: iconColor,
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(iconPadding ?? 0),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              color: borderColor,
            ),
          ),
        ),
      ),
    );
  }
}
