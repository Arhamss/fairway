import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingFlowCubit>().loadAirports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: BlocConsumer<OnboardingFlowCubit, OnboardingFlowState>(
        listener: (context, state) {
          if (state.location?.isFailure ?? false) {
            ToastHelper.showInfoToast(
              state.location?.errorMessage ?? 'Failed to get location',
            );
          } else if (state.location?.isLoaded ?? false) {
            locationController.text = state.location!.data!;
            ToastHelper.showInfoToast('Location set successfully');
          }

          if (state.updateLocation?.isLoaded ?? false) {
            // context.goNamed(AppRouteNames.home);
          } else if (state.updateLocation?.isFailure ?? false) {
            ToastHelper.showErrorToast(
              state.updateLocation?.errorMessage ?? 'Failed to update location',
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.location?.isLoading ?? false;
          final isLoadingAirports = state.airports?.isLoading ?? false;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      AssetPaths.location,
                      height: 160,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                      'Nearby terminal Restaurants',
                      style: context.h1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your location to allow access to your location to find restaurants near you.',
                      style: context.b2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    FairwayButton(
                      borderRadius: 15,
                      backgroundColor: AppColors.greyShade5,
                      onPressed: () => context
                          .read<OnboardingFlowCubit>()
                          .getCurrentLocation(),
                      text: 'Use current location',
                      isLoading: isLoading,
                      borderColor: AppColors.greyShade5,
                      splashColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    FairwayTextField(
                      type: FairwayTextFieldType.location,
                      hintText: 'Search for airport',
                      controller: locationController,
                      onChanged: (value) => context
                          .read<OnboardingFlowCubit>()
                          .onLocationInput(value),
                    ),
                    if (isLoadingAirports)
                      const Center(child: CircularProgressIndicator())
                    else if (state.filteredAirports.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: state.filteredAirports.length,
                          itemBuilder: (context, index) {
                            final airport = state.filteredAirports[index];
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              title: Text(
                                airport.name,
                                style: context.b1.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${airport.name} ${airport.code}',
                                style: context.b2,
                              ),
                              onTap: () {
                                // Update text field and select airport in one go
                                locationController.text =
                                    '${airport.name}, ${airport.code}';
                                context
                                    .read<OnboardingFlowCubit>()
                                    .selectAirport(airport);
                                FocusScope.of(context)
                                    .unfocus(); // Hide keyboard
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<OnboardingFlowCubit, OnboardingFlowState>(
              listener: (context, state) {
                if (state.updateLocation?.isLoaded ?? false) {
                  // context.goNamed(AppRouteNames.home);
                } else if (state.updateLocation?.isFailure ?? false) {
                  ToastHelper.showErrorToast(
                    state.updateLocation?.errorMessage ??
                        'Failed to update location',
                  );
                }
              },
              builder: (context, state) {
                return FairwayButton(
                  borderRadius: 15,
                  backgroundColor: AppColors.primaryButton,
                  onPressed: state.hasSelectedLocation
                      ? () =>
                          context.read<OnboardingFlowCubit>().updateLocation()
                      : null,
                  text: 'Next',
                  textColor: AppColors.white,
                  borderColor: Colors.transparent,
                  disabled: !state.hasSelectedLocation,
                  isLoading: state.updateLocation?.isLoading ?? false,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }
}
