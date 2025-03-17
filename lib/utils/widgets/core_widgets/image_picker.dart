import 'dart:io';

import 'package:fairway/export.dart';

class FairwayImagePicker extends StatelessWidget {
  const FairwayImagePicker({
    required this.onButtonPressed,
    required this.imagePath,
    super.key,
  });

  final VoidCallback onButtonPressed;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: onButtonPressed,
          icon: imagePath == null || (imagePath ?? '').isEmpty
              ? SvgPicture.asset(AssetPaths.importGalleryIcon)
              : ClipOval(
                  child: _getImageWidget(imagePath!),
                ),
          padding: EdgeInsets.all(
              imagePath == null || (imagePath ?? '').isEmpty ? 50 : 0),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            side: const BorderSide(
              color: AppColors.textFieldBorder,
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              onPressed: onButtonPressed,
              icon: SvgPicture.asset(
                AssetPaths.cameraFilledIcon,
                width: 18,
                height: 18,
              ),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getImageWidget(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath.replaceFirst('file://', '')),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    }
  }
}
