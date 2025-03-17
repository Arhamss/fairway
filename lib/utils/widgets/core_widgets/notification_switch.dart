import 'package:fairway/export.dart';
import 'package:flutter/cupertino.dart';

class NotificationSwitch extends StatelessWidget {
  const NotificationSwitch({
    required this.title,
    required this.switchValue,
    required this.onSwitchChanged,
    super.key,
  });

  final String title;
  final bool switchValue;
  final dynamic Function(bool) onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.textFieldBorder,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.b1.copyWith(
                color: AppColors.black,
              ),
            ),
            CupertinoSwitch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeTrackColor: AppColors.greenPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
