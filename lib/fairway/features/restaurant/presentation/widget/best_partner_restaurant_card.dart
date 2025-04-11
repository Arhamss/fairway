import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_card/restaurant_card_image.dart';
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
                flex: 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                    bottom: Radius.circular(15),
                  ),
                  child: RestaurantCardImage(
                    imageUrl: restaurant.images,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: Text(
                  restaurant.name,
                  textAlign: TextAlign.start,
                  style: context.t1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
