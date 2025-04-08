import 'package:fairway/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountTypeWidget extends StatelessWidget {
  const AccountTypeWidget({required this.accountType, super.key});

  final AccountType accountType;

  @override
  Widget build(BuildContext context) {
    // Determine the icon and text based on the account type
    final String iconPath;
    final String text;

    switch (accountType) {
      case AccountType.google:
        iconPath = AssetPaths.googleIcon; // Replace with the actual path
        text = 'Signed up with Google';
      case AccountType.apple:
        iconPath = AssetPaths.appleIcon; // Replace with the actual path
        text = 'Signed up with Apple ID';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.greyShade5,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: context.b1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AccountType {
  google,
  apple,
}
