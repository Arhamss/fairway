import 'package:fairway/export.dart';

class RestaurantCardPlaceholder extends StatelessWidget {
  const RestaurantCardPlaceholder({
    this.height,
    super.key,
  });
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const ColoredBox(
        color: AppColors.greyShade2,
        child: Center(
          child: Icon(
            Icons.restaurant,
            size: 40,
            color: AppColors.greyShade5,
          ),
        ),
      ),
    );
  }
}
