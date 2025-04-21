import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/locker.dart';
import 'package:flutter/material.dart';

class OrderLockerDetails extends StatelessWidget {
  const OrderLockerDetails({
    required this.lockerNumber,
    required this.passcode,
    super.key,
    this.unassignTime = 15,
  });

  final String lockerNumber;
  final String passcode;
  final int unassignTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.greyShade7,
                  size: 35,
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetPaths.lockerIcon,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Your order\nwill be Concierge to your locker.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Your locker number is $lockerNumber',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),
                    LockerPasscode(pin: passcode),

                    const SizedBox(height: 24),

                    // Unassign warning
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Your Locker will be unassigned in $unassignTime minutes',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
