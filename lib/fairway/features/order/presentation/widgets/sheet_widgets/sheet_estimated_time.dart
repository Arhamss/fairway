import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';

class EstimatedTime extends StatelessWidget {
  const EstimatedTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.greyShade7,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Estimated Time',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${state.orderResponseModel.data!.estimatedTime}mins',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
