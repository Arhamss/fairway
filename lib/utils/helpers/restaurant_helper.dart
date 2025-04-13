import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_method_dialog.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';

class RestaurantHelper {
  static void showOrderMethodDialog(
    BuildContext context,
    String restaurantId,
  ) {
    showDialog<dynamic>(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.7),
      builder: (context) => OrderMethodDialog(
        restaurantId: restaurantId,
      ),
    );
  }
}
