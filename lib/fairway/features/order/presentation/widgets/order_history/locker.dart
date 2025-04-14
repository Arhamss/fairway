import 'package:fairway/export.dart';

class LockerInfo extends StatelessWidget {
  const LockerInfo({
    required this.lockerCode,
    super.key,
  });

  final String lockerCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Text(
        'Locker Number is L ${lockerCode.substring(0, 2)}',
        style: context.b1.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColors.greyShade7,
        ),
      ),
    );
  }
}

class LockerPasscode extends StatelessWidget {
  const LockerPasscode({
    required this.pin,
    super.key,
  });

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'REMEMBER LOCKER PASSCODE',
            style: TextStyle(
              fontSize: 12.83,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.37,
              color: AppColors.black,
            ),
          ),
        ),
        // Passcode digits
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildPasscodeDigits(pin),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPasscodeDigits(String pin) {
    return pin.split('').map((digit) {
      return PasscodeDigit(digit: digit);
    }).toList();
  }
}

class PasscodeDigit extends StatelessWidget {
  const PasscodeDigit({
    required this.digit,
    super.key,
  });

  final String digit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: 43.08,
      height: 43.08,
      decoration: BoxDecoration(
        color: AppColors.greyShade5,
        border: Border.all(
          color: AppColors.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            digit,
            style: const TextStyle(
              fontSize: 11.68,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            width: 21.18,
            height: 1.33,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
