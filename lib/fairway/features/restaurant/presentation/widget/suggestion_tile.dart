import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/cubit.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/helpers/restaurant_helper.dart';

class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    required this.suggestion,
    super.key,
  });

  final SuggestionItem suggestion;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: suggestion.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: suggestion.images,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.greyShade5,
                  child: const Center(child: LoadingWidget(size: 20)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.greyShade5,
                  child: const Icon(
                    Icons.restaurant,
                    color: AppColors.greyShade2,
                  ),
                ),
              )
            : Container(
                width: 56,
                height: 56,
                color: AppColors.greyShade5,
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.greyShade2,
                ),
              ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              suggestion.name,
              style: context.b1.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (suggestion.bestPartner)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.star,
                size: 16,
                color: AppColors.primaryAmber,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.categories.map((Category e) => e.name).join(', '),
            style: context.b3.copyWith(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${suggestion.airport.name} (${suggestion.airport.code})',
            style: context.b3.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      onTap: () {
        context.read<RestaurantCubit>().searchRestaurants(suggestion.name);
        RestaurantHelper.showOrderMethodDialog(
          context,
          suggestion.id,
        );
      },
    );
  }
}
