import 'package:fairway/export.dart';

class FairwayDivider extends StatelessWidget {
  const FairwayDivider({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      color: AppColors.dividerColor,
      height: 1,
      width: double.infinity,
    );
  }
}
