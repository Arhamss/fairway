import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/utils/helpers/url_helper.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';

class BestPartnerRestaurantCard extends StatelessWidget {
  const BestPartnerRestaurantCard({
    required this.restaurant,
    super.key,
    this.width,
    this.onTap,
    this.margin,
  });

  final RestaurantModel restaurant;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () => RestaurantHelper.showOrderMethodDialog(
                context,
                restaurant.website,
              ),
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.7,
        margin: margin ?? const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                    bottom: Radius.circular(15),
                  ),
                  child: restaurant.images.isNotEmpty
                      ? Image.network(
                          restaurant.images,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const _PlaceholderImage();
                          },
                        )
                      : const _PlaceholderImage(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      textAlign: TextAlign.start,
                      style: context.b1
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to visit website',
                      style: context.l3.copyWith(
                        color: AppColors.greyShade5,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.greyShade2,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 40,
          color: AppColors.greyShade5,
        ),
      ),
    );
  }
}
