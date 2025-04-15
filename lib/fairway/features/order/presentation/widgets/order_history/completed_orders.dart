import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';

class CompletedOrdersList extends StatelessWidget {
  const CompletedOrdersList({
    required this.orders,
    super.key,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    // For now, just show a placeholder message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 64,
            color: AppColors.greyShade5,
          ),
          const SizedBox(height: 16),
          Text(
            'Completed orders will be shown here',
            style: context.b1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
