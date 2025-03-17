import 'package:fairway/export.dart';

class FairwayStackedImages extends StatelessWidget {
  const FairwayStackedImages({
    required this.images,
    required this.size,
    required this.maxImages,
    super.key,
  });

  final List<String> images;
  final double size;
  final int maxImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < images.take(maxImages).length; i++)
            Positioned(
              left: i * (size * 0.6),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                  ),
                ),
                child: CircleAvatar(
                  radius: size / 2,
                  backgroundImage: AssetImage(images[i]),
                  backgroundColor: AppColors.white,
                ),
              ),
            ),
          if (images.length > maxImages)
            Positioned(
              left: maxImages * (size * 0.6),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size * 0.4),
                decoration: BoxDecoration(
                  color: AppColors.greenChipColor,
                  borderRadius: BorderRadius.circular(size / 2),
                  border: Border.all(
                    color: AppColors.white,
                  ),
                ),
                constraints: BoxConstraints(
                  minHeight: size,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+${images.length - maxImages}',
                  style: context.l3.copyWith(
                    fontSize: size * 0.3,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
