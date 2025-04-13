import 'package:fairway/export.dart';

class FoodDeliveredGrid extends StatelessWidget {
  const FoodDeliveredGrid({
    required this.items,
    super.key,
  });

  final List<DeliveredFoodItem> items;

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

  final DeliveredFoodItem item;

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
            image: DecorationImage(
              image: AssetImage(item.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          textAlign: TextAlign.left,
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

class DeliveredFoodItem {
  const DeliveredFoodItem({
    required this.imagePath,
    required this.quantity,
  });
  final String imagePath;
  final int quantity;
}
