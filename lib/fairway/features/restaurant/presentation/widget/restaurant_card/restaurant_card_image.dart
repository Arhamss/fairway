import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/restaurant_card/restaurant_card_placeholder.dart';
import 'package:flutter/material.dart';

class RestaurantCardImage extends StatelessWidget {
  const RestaurantCardImage({
    required this.imageUrl,
    super.key,
    this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => RestaurantCardPlaceholder(
        height: height,
      ),
      errorWidget: (context, url, error) => RestaurantCardPlaceholder(
        height: height,
      ),
    );
  }
}
