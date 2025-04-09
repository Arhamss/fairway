import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantSearchTile extends StatelessWidget {
  const RestaurantSearchTile({
    required this.restaurant,
    super.key,
  });

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: restaurant.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: restaurant.images,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerPlaceholder(),
                errorWidget: (context, url, error) => _buildErrorPlaceholder(),
              )
            : _buildErrorPlaceholder(),
      ),
      title: Text(
        restaurant.name,
        style: context.b1.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        restaurant.categories.join(', '),
        style: context.l3.copyWith(color: AppColors.black),
      ),
      onTap: () => UrlHelper.launchWebsite(restaurant.website),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyShade4,
      highlightColor: AppColors.greyShade2,
      child: Container(
        width: 50,
        height: 50,
        color: AppColors.greyShade4,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.greyShade2,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 30,
          color: AppColors.greyShade5,
        ),
      ),
    );
  }
}
