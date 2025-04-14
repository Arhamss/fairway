import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/order_history_card.dart';

class InProgressOrdersList extends StatelessWidget {
  const InProgressOrdersList({
    required this.orders,
    super.key,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    // Filter orders that are in progress (preparing, ready, enroute)
    final inProgressOrders = orders.where((order) {
      final status = order.status.toLowerCase();
      return status == 'preparing' || status == 'ready' || status == 'enroute';
    }).toList();

    if (inProgressOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_empty_outlined,
              size: 64,
              color: AppColors.greyShade5,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders in progress',
              style: context.b1.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: inProgressOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = inProgressOrders[index];
        return OrderHistoryCard(order: order);
      },
    );
  }
}
