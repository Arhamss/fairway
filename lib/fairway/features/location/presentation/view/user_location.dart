import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';

class UserLocationScreen extends StatelessWidget {
  const UserLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        forceMaterialTransparency: true,
        title: Text(
          'My Locations',
          style: context.h3.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.userProfile.isLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          if (state.userProfile.isFailure) {
            return Center(
              child: Text(
                'Error loading profile',
                style: context.b1.copyWith(color: AppColors.error),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current Location',
                  style: context.b2.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  state.userProfile.data?.location ?? 'Unknown',
                  style: context.b1,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    //  context.read<HomeCubit>().updateUserLocation();
                  },
                  child: const Text('Update Location'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
