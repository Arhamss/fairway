import 'package:fairway/export.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: AppColors.greenPrimary,
        size: size,
      ),
    );
  }
}
