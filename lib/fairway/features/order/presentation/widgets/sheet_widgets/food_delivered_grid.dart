import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_item_model.dart';

class FoodDeliveredGrid extends StatelessWidget {
  const FoodDeliveredGrid({
    required this.items,
    super.key,
  });

  final List<OrderItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Food Delivered',
          style: context.h3.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.2,
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return DeliveredFoodItemTile(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class DeliveredFoodItemTile extends StatelessWidget {
  const DeliveredFoodItemTile({
    required this.item,
    super.key,
  });

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppColors.greyShade2,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.greyShade7,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const ColoredBox(
                  color: AppColors.greyShade2,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'x${item.quantity}',
          style: context.b2.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
