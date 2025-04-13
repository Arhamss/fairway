import 'package:fairway/export.dart';
import 'package:shimmer/shimmer.dart';

class BestPartnerShimmerCard extends StatelessWidget {
  const BestPartnerShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Shimmer.fromColors(
          baseColor: AppColors.greyShade4,
          highlightColor: AppColors.greyShade3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.greyShade4,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                      bottom: Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.greyShade4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
