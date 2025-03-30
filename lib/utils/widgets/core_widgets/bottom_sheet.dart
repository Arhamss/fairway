import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';

class BammbuuBottomSheet extends StatelessWidget {
  const BammbuuBottomSheet.FairwayBottomSheet({
    required this.title,
    this.onTap,
    this.imagePath,
    this.buttonText,
    this.subtitle,
    this.richTextWidget,
    this.showTwoButtons = false,
    this.buttonOneText,
    this.buttonTwoText,
    this.buttonOneOnTap,
    this.buttonTwoOnTap,
    this.buttonOneColor,
    this.buttonTwoColor,
    this.buttonOnePrefix,
    this.buttonTwoPrefix,
    this.buttonTwoIsLoading = false,
    this.isLoading = false,
    this.buttonColor = AppColors.primary,
    this.textBelowButton,
    this.onTapTextBelowButton,
    this.titleAlignment,
    this.bodyWidget,
    this.noteText,
    this.height,
    super.key,
  });

  final String? imagePath;
  final String title;
  final String? subtitle;
  final Widget? richTextWidget;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color buttonColor;
  final String? textBelowButton;
  final VoidCallback? onTapTextBelowButton;
  final Widget? bodyWidget;
  final bool showTwoButtons;
  final String? buttonOneText;
  final String? buttonTwoText;
  final VoidCallback? buttonOneOnTap;
  final VoidCallback? buttonTwoOnTap;
  final Color? buttonOneColor;
  final Color? buttonTwoColor;
  final Widget? buttonOnePrefix;
  final Widget? buttonTwoPrefix;
  final TextAlign? titleAlignment;
  final bool buttonTwoIsLoading;
  final String? noteText;

  final double? height;

  static void show({
    required BuildContext context,
    required String title,
    String? imagePath,
    String? buttonText,
    VoidCallback? onTap,
    String? subtitle,
    Widget? richTextWidget,
    bool isLoading = false,
    Color buttonColor = AppColors.primary,
    String? textBelowButton,
    VoidCallback? onTapTextBelowButton,
    bool showTwoButtons = false,
    String? buttonOneText,
    String? buttonTwoText,
    VoidCallback? buttonOneOnTap,
    VoidCallback? buttonTwoOnTap,
    Color? buttonOneColor,
    Color? buttonTwoColor,
    Widget? buttonOnePrefix,
    Widget? buttonTwoPrefix,
    TextAlign? titleAlignment,
    Widget? bodyWidget,
    bool buttonTwoIsLoading = false,
    String? noteText,
    double? height,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: height != null
              ? MediaQuery.of(context).size.height * height
              : null,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: BammbuuBottomSheet.FairwayBottomSheet(
              imagePath: imagePath,
              title: title,
              subtitle: subtitle,
              richTextWidget: richTextWidget,
              buttonText: buttonText,
              onTap: onTap,
              isLoading: isLoading,
              buttonColor: buttonColor,
              textBelowButton: textBelowButton,
              onTapTextBelowButton: onTapTextBelowButton,
              showTwoButtons: showTwoButtons,
              buttonOneText: buttonOneText,
              buttonTwoText: buttonTwoText,
              buttonOneOnTap: buttonOneOnTap,
              buttonTwoOnTap: buttonTwoOnTap,
              buttonOneColor: buttonOneColor,
              buttonTwoColor: buttonTwoColor,
              buttonOnePrefix: buttonOnePrefix,
              buttonTwoPrefix: buttonTwoPrefix,
              titleAlignment: titleAlignment,
              bodyWidget: bodyWidget,
              buttonTwoIsLoading: buttonTwoIsLoading,
              noteText: noteText,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF161810).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          if (imagePath != null)
            SvgPicture.asset(
              imagePath!,
              height: 100,
            ),
          const SizedBox(height: 24),
          Text(
            title,
            style: context.h3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: titleAlignment,
          ),
          const SizedBox(height: 12),
          if (richTextWidget != null)
            richTextWidget!
          else if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.b2.copyWith(
                fontSize: 13,
              ),
            ),
          if (noteText != null)
            Text(
              noteText!,
              textAlign: TextAlign.center,
              style: context.h1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          if (bodyWidget != null) bodyWidget!,
          const SizedBox(height: 24),
          if (showTwoButtons) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FairwayButton(
                    borderColor: AppColors.disabled,
                    prefixIcon: buttonOnePrefix,
                    text: buttonOneText ?? '',
                    onPressed: buttonOneOnTap,
                    isLoading: isLoading,
                    backgroundColor: buttonOneColor ?? AppColors.greenPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FairwayButton(
                    borderColor: AppColors.disabled,
                    prefixIcon: buttonTwoPrefix,
                    text: buttonTwoText ?? '',
                    onPressed: buttonTwoOnTap,
                    isLoading: buttonTwoIsLoading,
                    backgroundColor: buttonTwoColor ?? AppColors.primary,
                  ),
                ),
              ],
            ),
          ] else if (buttonText != null) ...[
            FairwayButton(
              text: buttonText!,
              onPressed: onTap,
              isLoading: isLoading,
              backgroundColor: buttonColor,
            ),
          ],
          const SizedBox(height: 16),
          if (textBelowButton != null) ...[
            GestureDetector(
              onTap: onTapTextBelowButton,
              child: Text(
                textBelowButton ?? '',
                style: context.b2,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class BammbuuBottomSheetAddClasses extends StatelessWidget {
  const BammbuuBottomSheetAddClasses({
    this.title,
    this.onTap,
    this.imagePath,
    this.buttonText,
    this.subtitle,
    this.richTextWidget,
    this.showTwoButtons = false,
    this.buttonOneText,
    this.buttonTwoText,
    this.buttonOneOnTap,
    this.buttonTwoOnTap,
    this.buttonOneColor,
    this.buttonTwoColor,
    this.buttonOnePrefix,
    this.buttonTwoPrefix,
    this.buttonTwoIsLoading = false,
    this.isLoading = false,
    this.buttonColor = AppColors.primary,
    this.textBelowButton,
    this.onTapTextBelowButton,
    this.titleAlignment,
    this.bodyWidget,
    this.noteText,
    super.key,
  });

  final String? imagePath;
  final String? title;
  final String? subtitle;
  final Widget? richTextWidget;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color buttonColor;
  final String? textBelowButton;
  final VoidCallback? onTapTextBelowButton;
  final Widget? bodyWidget;
  final bool showTwoButtons;
  final String? buttonOneText;
  final String? buttonTwoText;
  final VoidCallback? buttonOneOnTap;
  final VoidCallback? buttonTwoOnTap;
  final Color? buttonOneColor;
  final Color? buttonTwoColor;
  final Widget? buttonOnePrefix;
  final Widget? buttonTwoPrefix;
  final TextAlign? titleAlignment;
  final bool buttonTwoIsLoading;
  final String? noteText;

  static void show({
    required BuildContext context,
    required String title,
    String? imagePath,
    String? buttonText,
    VoidCallback? onTap,
    String? subtitle,
    Widget? richTextWidget,
    bool isLoading = false,
    Color buttonColor = AppColors.primary,
    String? textBelowButton,
    VoidCallback? onTapTextBelowButton,
    bool showTwoButtons = false,
    String? buttonOneText,
    String? buttonTwoText,
    VoidCallback? buttonOneOnTap,
    VoidCallback? buttonTwoOnTap,
    Color? buttonOneColor,
    Color? buttonTwoColor,
    Widget? buttonOnePrefix,
    Widget? buttonTwoPrefix,
    TextAlign? titleAlignment,
    Widget? bodyWidget,
    bool buttonTwoIsLoading = false,
    String? noteText,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BammbuuBottomSheetAddClasses(
          imagePath: imagePath,
          title: title,
          subtitle: subtitle,
          richTextWidget: richTextWidget,
          buttonText: buttonText,
          onTap: onTap,
          isLoading: isLoading,
          buttonColor: buttonColor,
          textBelowButton: textBelowButton,
          onTapTextBelowButton: onTapTextBelowButton,
          showTwoButtons: showTwoButtons,
          buttonOneText: buttonOneText,
          buttonTwoText: buttonTwoText,
          buttonOneOnTap: buttonOneOnTap,
          buttonTwoOnTap: buttonTwoOnTap,
          buttonOneColor: buttonOneColor,
          buttonTwoColor: buttonTwoColor,
          buttonOnePrefix: buttonOnePrefix,
          buttonTwoPrefix: buttonTwoPrefix,
          titleAlignment: titleAlignment,
          bodyWidget: bodyWidget,
          buttonTwoIsLoading: buttonTwoIsLoading,
          noteText: noteText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF161810).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),
          if (subtitle != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: context.h3.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          const SizedBox(height: 7),
          if (bodyWidget != null) bodyWidget!,
          const SizedBox(height: 3),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: context.b2.copyWith(
              fontSize: 12,
              color: AppColors.greyShade1,
            ),
          ),
          const SizedBox(height: 24),
          FairwayButton(
            text: buttonText!,
            onPressed: onTap,
            isLoading: isLoading,
            backgroundColor: buttonColor,
          ),
          const SizedBox(height: 16),
          if (richTextWidget != null) ...[
            richTextWidget!,
            const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}
