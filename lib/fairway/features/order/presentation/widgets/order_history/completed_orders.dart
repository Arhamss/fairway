import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/order_history_card.dart';

class CompletedOrdersList extends StatelessWidget {
  const CompletedOrdersList({
    required this.orders,
    super.key,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    // Filter orders that are in progress (preparing, ready, enroute)
    final activeOrders = orders.where((order) {
      final status = order.status.toLowerCase();
      return status == OrderPreparationState.pickedByCustomer.toName;
    }).toList();

    if (activeOrders.isEmpty) {
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
      itemCount: activeOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = activeOrders.reversed.toList()[index];
        return OrderHistoryCard(order: order);
      },
    );
  }
}
