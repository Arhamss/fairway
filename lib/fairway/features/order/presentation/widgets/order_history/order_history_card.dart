import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/airport_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_item_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/airport_info.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/food_items_list.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/locker.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/restaurant_header.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/order_preparation_status.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({
    required this.order,
    super.key,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final hasLocker = order.lockerOrderCode != null && order.lockerPin != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestaurantHeader(order: order),
          const SizedBox(height: 8),
          if (order.items.isNotEmpty) FoodItemsList(items: order.items),
          if (hasLocker) LockerInfo(lockerCode: order.lockerOrderCode ?? '32'),
          AirportInfo(airport: order.airport),
          if (hasLocker &&
              order.status != OrderPreparationState.pickedByCustomer.toName)
            LockerPasscode(pin: order.lockerPin ?? '000000'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
