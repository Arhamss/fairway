import 'package:fairway/export.dart';
import 'package:flutter/gestures.dart';

class FairwayRichText extends StatelessWidget {
  const FairwayRichText({
    required this.textBefore,
    required this.richText,
    required this.textAfter,
    super.key,
    this.normalTextStyle,
    this.richTextStyle,
    this.richTextColor,
    this.onRichTextTap,
    this.textAlign = TextAlign.center,
    this.noSpace = false,
  });

  final TextStyle? normalTextStyle;
  final TextStyle? richTextStyle;
  final bool noSpace;
  final String textBefore;
  final String textAfter;
  final String richText;
  final Color? richTextColor;
  final VoidCallback? onRichTextTap;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: textBefore,
        style: normalTextStyle ??
            context.b3.copyWith(
              color: AppColors.textFaded,
            ),
        children: [
          TextSpan(
            text: noSpace ? richText : ' $richText ',
            style: richTextStyle ??
                context.b3.copyWith(
                  color: richTextColor ?? AppColors.black,
                ),
            recognizer: TapGestureRecognizer()..onTap = onRichTextTap,
          ),
          TextSpan(
            text: textAfter,
            style: normalTextStyle ??
                context.b3.copyWith(
                  color: AppColors.textFaded,
                ),
          ),
        ],
      ),
    );
  }
}
