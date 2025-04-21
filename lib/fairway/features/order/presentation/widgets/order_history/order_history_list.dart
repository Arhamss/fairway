import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/order_history_card.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({
    required this.orders,
    super.key,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders yet',
          style: context.b1.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderHistoryCard(order: order);
      },
    );
  }
}
