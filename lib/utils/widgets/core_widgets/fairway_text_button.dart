import 'package:fairway/export.dart';

class FairwayTextButton extends StatelessWidget {
  const FairwayTextButton({
    required this.onPressed,
    required this.text,
    this.textStyle,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: AppColors.black,
        overlayColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: textStyle ??
            context.b2.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
