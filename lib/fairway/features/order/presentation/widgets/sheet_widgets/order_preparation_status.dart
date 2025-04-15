import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';

class OrderPreparationStatus extends StatelessWidget {
  const OrderPreparationStatus({
    required this.currentState,
    super.key,
    this.estimatedTime = '20',
  });

  final OrderPreparationState currentState;
  final String estimatedTime;

  @override
  Widget build(BuildContext context) {
    // Get next state if available
    OrderPreparationState? nextState;
    if (currentState.index < OrderPreparationState.values.length - 1) {
      nextState = OrderPreparationState.values[currentState.index + 1];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greyShade7.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Current state
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(
                    AssetPaths.locationGroup,
                    width: 20,
                    height: 20,
                  ),
                  if (nextState != null) ...[
                    Container(
                      width: 4,
                      height: 128,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                      ), // Added margin
                      decoration: BoxDecoration(
                        color: AppColors.greyShade3,
                        borderRadius:
                            BorderRadius.circular(1.5), // Rounded corners
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentState.title,
                      style: context.h2.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentState.description,
                      style: context.b2.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (currentState == OrderPreparationState.preparing) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Time Req. ${estimatedTime}mins',
                        style: context.h3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Next state if available
          if (nextState != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    AssetPaths.locationGroup,
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nextState.title,
                    style: context.h2.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyShade8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
