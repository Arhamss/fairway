import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_card/restaurant_card_image.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    required this.restaurant,
    super.key,
  });

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => RestaurantHelper.showOrderMethodDialog(
        context,
        restaurant.website,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: RestaurantCardImage(
                imageUrl: restaurant.images,
                height: 180,
              ),
            ),
            _buildRestaurantDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: context.b1.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: restaurant.categories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greyShade5,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category.name,
                  style: context.l3.copyWith(
                    color: AppColors.black,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Open',
            style: context.b3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
