import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/order_item_model.dart';

class FoodItemsList extends StatelessWidget {
  const FoodItemsList({
    required this.items,
    super.key,
  });

  final List<OrderItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Food Delivered',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return FoodItemTile(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class FoodItemTile extends StatelessWidget {
  const FoodItemTile({
    required this.item,
    super.key,
  });

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.image,
            width: 53.3,
            height: 53.3,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 53.3,
              height: 53.3,
              color: AppColors.greyShade2,
              child: const Icon(Icons.fastfood),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'x${item.quantity}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
