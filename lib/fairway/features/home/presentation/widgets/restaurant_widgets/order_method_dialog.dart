import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/fairway_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderMethodDialog extends StatelessWidget {
  const OrderMethodDialog({required this.restaurantLink, super.key});

  final String restaurantLink;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Order Method',
                  style: context.h2.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      label: 'Pick Yourself',
                      iconPath: AssetPaths.pickYourselfIcon,
                      isSelected:
                          state.selectedOrderMethod == OrderMethod.pickYourself,
                      onTap: () => context
                          .read<RestaurantCubit>()
                          .selectOrderMethod(OrderMethod.pickYourself),
                    ),
                    _buildOption(
                      context,
                      label: 'Concierge',
                      iconPath: AssetPaths.conciergeIcon,
                      isSelected:
                          state.selectedOrderMethod == OrderMethod.concierge,
                      onTap: () => context
                          .read<RestaurantCubit>()
                          .selectOrderMethod(OrderMethod.concierge),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FairwayButton(
                  text: 'Confirm',
                  borderRadius: 12,
                  onPressed: state.selectedOrderMethod != null
                      ? () async {
                          Navigator.of(context).pop();
                          final uri = Uri.parse(restaurantLink);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            ToastHelper.showErrorToast(
                                'Could not launch the website');
                          }
                        }
                      : null,
                  textColor: AppColors.white,
                  disabled: state.selectedOrderMethod == null,
                  isLoading: false,
                ),
                const SizedBox(height: 8),
                FairwayTextButton(
                  onPressed: () {
                    print('Cancel Pressed');
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.greyShade5,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.03)
              : AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 72,
            ),
            const SizedBox(height: 12),
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
