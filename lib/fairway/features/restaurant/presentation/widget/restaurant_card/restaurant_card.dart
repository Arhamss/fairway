import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_card/restaurant_card_image.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    required this.restaurant,
    super.key,
  });

  final RestaurantModel restaurant;

  bool _isAvailableAtLocation(BuildContext context) {
    final locationState = context.read<HomeCubit>().state;
    return restaurant.airport.code ==
        locationState.userProfile.data!.savedLocations
            .firstWhere(
              (location) => location.isCurrent,
            )
            .airportCode;
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = _isAvailableAtLocation(context);

    return InkWell(
      onTap: isAvailable
          ? () => RestaurantHelper.showOrderMethodDialog(
                context,
                restaurant.website,
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: RestaurantCardImage(
                    imageUrl: restaurant.images,
                    height: 180,
                  ),
                ),
                if (!isAvailable)
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: 180,
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '${restaurant.name} is not available in your location',
                            style: context.b2.copyWith(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            _buildRestaurantDetails(context, isAvailable),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantDetails(BuildContext context, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: context.b1.copyWith(
              fontWeight: FontWeight.w700,
              color:
                  isAvailable ? AppColors.textPrimary : AppColors.textSecondary,
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
                    color:
                        isAvailable ? AppColors.black : AppColors.textSecondary,
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
              color:
                  isAvailable ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
