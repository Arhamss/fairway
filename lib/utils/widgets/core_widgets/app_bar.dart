import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/icon_button.dart';

PreferredSizeWidget fairwayAppBar({
  required BuildContext context,
  required String title,
  VoidCallback? onLeadingPressed,
  String? actionText,
  TextStyle? titleStyle,
  TextStyle? actionTextStyle,
  Widget? actionWidget,
  double elevation = 0.0,
  bool forceMaterialTransparency = true,
  bool centerTitle = false,
  double titleSpacing = 16.0,
  Widget? leadingIcon,
  bool showLeading = true,
  double actionsPadding = 16,
}) {
  return AppBar(
    elevation: elevation,
    forceMaterialTransparency: forceMaterialTransparency,
    centerTitle: centerTitle,
    titleSpacing: titleSpacing,
    leadingWidth: 64,
    automaticallyImplyLeading: false,
    leading: showLeading
        ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: leadingIcon ??
                FairwayIconButton(
                  onPressed: onLeadingPressed,
                ),
          )
        : null,
    title: Text(
      title,
      style: titleStyle ??
          context.b1.copyWith(
            fontSize: 20,
          ),
    ),
    actions: actionText != null
        ? [
            Text(
              actionText,
              style: actionTextStyle ?? context.b2,
            ),
            const SizedBox(width: 16),
          ]
        : actionWidget != null
            ? [
                actionWidget,
                SizedBox(width: actionsPadding),
              ]
            : [],
  );
}
