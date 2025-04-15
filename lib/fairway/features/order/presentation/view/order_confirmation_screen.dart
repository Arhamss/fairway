import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/presentation/view/order_details_sheet.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/delivery_details_row.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.greyShade7,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      AssetPaths.confettiIcon,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Yay, Your order\nhas been placed.',
                      textAlign: TextAlign.center,
                      style: context.h1.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your order would be delivered in the\n${state.orderResponseModel.data!.order.estimatedTime} mins almost!',
                      textAlign: TextAlign.center,
                      style: context.b1.copyWith(
                        color: AppColors.greyShade7,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _OrderDetailItem(
                            label: 'Estimated time',
                            value:
                                '${state.orderResponseModel.data!.order.estimatedTime}mins',
                          ),
                          const SizedBox(height: 12),
                          _OrderDetailItem(
                            label: 'Amount Paid',
                            value:
                                '\$${state.orderResponseModel.data!.order.totalPrice}',
                            svgPath: AssetPaths.walletIcon,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.all(24),
                child: FairwayButton(
                  text: 'See Order Details',
                  padding: const EdgeInsets.all(18),
                  borderRadius: 16,
                  onPressed: () async {
                    context.pop();
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => const OrderDetailsSheet(),
                      isScrollControlled: true,
                      isDismissible: false,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  textColor: AppColors.white,
                  isLoading: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderDetailItem extends StatelessWidget {
  const _OrderDetailItem({
    required this.label,
    required this.value,
    this.svgPath,
  });

  final String label;
  final String value;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (svgPath != null)
          SizedBox(
            width: 24,
            height: 24, // Added fixed height to match icon size
            child: Center(
              // Center the SVG
              child: SvgPicture.asset(
                svgPath!,
                width: 20,
                height: 20,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          const SizedBox(
            width: 24,
            height: 24,
            child: Center(
              // Center the icon
              child: Icon(
                Icons.access_time_rounded,
                color: AppColors.greyShade7,
                size: 20,
              ),
            ),
          ),
        const SizedBox(width: 12),
        Text(
          label,
          style: context.b2.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: context.h3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
