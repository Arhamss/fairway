import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';

class NearbyRestaurantCard extends StatelessWidget {
  const NearbyRestaurantCard({
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
              child: _buildRestaurantImage(),
            ),
            _buildRestaurantDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantImage() {
    return restaurant.images.isNotEmpty
        ? Image.network(
            restaurant.images,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          )
        : _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 180,
      color: AppColors.greyShade2,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 40,
          color: AppColors.greyShade5,
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
