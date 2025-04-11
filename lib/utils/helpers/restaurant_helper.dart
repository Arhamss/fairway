import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/restaurant_widgets/order_method_dialog.dart';

class RestaurantHelper {
  static void showOrderMethodDialog(
    BuildContext context,
    String restaurantUrl,
  ) {
    showDialog<dynamic>(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.7),
      builder: (context) => OrderMethodDialog(
        restaurantLink: restaurantUrl,
      ),
    );
  }
}
