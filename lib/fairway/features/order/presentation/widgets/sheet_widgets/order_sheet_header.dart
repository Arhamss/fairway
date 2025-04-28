import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';

class OrderSheetHeader extends StatefulWidget {
  const OrderSheetHeader({super.key});

  @override
  State<OrderSheetHeader> createState() => _OrderSheetHeaderState();
}

class _OrderSheetHeaderState extends State<OrderSheetHeader> {
  @override
  Widget build(BuildContext context) {
    // Listen to the OrderCubit state changes
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        AppLogger.info(
          'OrderSheetHeader: Building header with state: ${state.orderResponseModel}',
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue,
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.placeholderUserAvatar,
                    ), // Make sure to add this asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.orderResponseModel.data?.concierge?.name ??
                        'Not assigned',
                    style: context.h2.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Concierge',
                    style: context.b2.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
