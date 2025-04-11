import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderMethodDialog extends StatelessWidget {
  const OrderMethodDialog({required this.restaurantLink, super.key});

  final String restaurantLink;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestaurantCubit>();
    final state = context.watch<RestaurantCubit>().state;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // Remove SingleChildScrollView and ConstrainedBox - they're causing the issue
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important: use min size
          children: [
            Text(
              'Select Order Method',
              style: context.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOption(
                  context,
                  label: 'Pick Yourself',
                  iconPath: AssetPaths.pickYourselfIcon,
                  isSelected: state.selectedOrderMethod == 'Pick Yourself',
                  onTap: () => cubit.selectOrderMethod('Pick Yourself'),
                ),
                _buildOption(
                  context,
                  label: 'Concierge',
                  iconPath: AssetPaths.conciergeIcon,
                  isSelected: state.selectedOrderMethod == 'Concierge',
                  onTap: () => cubit.selectOrderMethod('Concierge'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Replace Column with Row and remove Expanded widgets
            Flexible(
              child: FairwayButton(
                text: 'Confirm',
                borderRadius: 16,
                onPressed: state.selectedOrderMethod != null
                    ? () async {
                        Navigator.of(context).pop();
                        if (await canLaunchUrl(Uri.parse(restaurantLink))) {
                          await launchUrl(Uri.parse(restaurantLink));
                        } else {
                          ToastHelper.showErrorToast(
                            'Could not launch the website',
                          );
                        }
                      }
                    : null,
                textColor: AppColors.white,
                disabled: state.selectedOrderMethod == null,
                isLoading: false,
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: () {
                  cubit.clearOrderMethod();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // This function is fine as is
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.greyShade2,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 100,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: context.b2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
