import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        forceMaterialTransparency: true,
        leading: const BackButton(color: AppColors.black),
        title: Text(
          'My Locations',
          style: context.h3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.userProfile.isLoading) {
            return const Center(child: LoadingWidget());
          }
          if (state.userProfile.isFailure) {
            return RetryWidget(
              message: state.userProfile.errorMessage ??
                  'An error occurred loading your saved locations',
              onRetry: () {
                context.read<HomeCubit>().loadUserProfile();
              },
            );
          }
          final locations = state.userProfile.data?.savedLocations ?? [];
          if (locations.isEmpty) {
            return Center(
              child: Text(
                'No saved locations',
                style: context.b1,
              ),
            );
          }
          return BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(locations.length, (index) {
                              final loc = locations[index];
                              final isSelected =
                                  state.selectedLocationIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<LocationCubit>()
                                      .selectSavedLocationIndex(index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: isSelected ? 1 : 0.75,
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.messageBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${loc.airportName}, ${loc.airportCode}',
                                              style: context.b2.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              loc.terminal,
                                              style: context.b3.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Gate ${loc.gate}',
                                              style: context.b3.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(AppRouteNames.selectLocation);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add,
                                        color: AppColors.primaryBlue),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add New Location',
                                      style: context.b1.copyWith(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FairwayButton(
                      text: 'Submit',
                      onPressed: state.selectedLocationIndex != null
                          ? () {
                              final selected =
                                  locations[state.selectedLocationIndex!];
                              AppLogger.info(
                                  'Selected Location: ${selected.toJson()}');
                            }
                          : null,
                      isLoading: false,
                      textColor: AppColors.white,
                      borderRadius: 16,
                      fontWeight: FontWeight.w600,
                      outsidePadding: const EdgeInsets.symmetric(vertical: 16),
                      disabled: state.selectedLocationIndex == null,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
