import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        forceMaterialTransparency: true,
      ),
      body: BlocConsumer<LocationCubit, LocationState>(
        listenWhen: (previous, current) =>
            previous.location != current.location ||
            previous.updateLocation != current.updateLocation ||
            previous.airports != current.airports,
        listener: (context, state) {
          if (state.updateLocation.isLoaded) {
            context.goNamed(AppRouteNames.homeScreen);
          }

          if (state.location.isFailure) {
            ToastHelper.showErrorToast(
              state.location.errorMessage ?? 'Failed to get location',
            );
          }
          if (state.airports.isFailure) {
            ToastHelper.showErrorToast(
              state.airports.errorMessage ?? 'Failed to load airports',
            );
          }
          if (state.updateLocation.isFailure) {
            ToastHelper.showErrorToast(
              state.updateLocation.errorMessage ?? 'Failed to update location',
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.location.isLoading;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      style: context.t1,
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
                      onPressed: () async {
                        await context
                            .read<LocationCubit>()
                            .getCurrentLocation();
                      },
                      prefixIcon: const Icon(
                        Icons.location_searching,
                      ),
                      text: 'Use current location',
                      isLoading: isLoading,
                      splashColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    FairwayTextField(
                      type: FairwayTextFieldType.location,
                      hintText: 'Search for airport',
                      controller: locationController,
                      onChanged: (value) =>
                          context.read<LocationCubit>().onLocationInput(value),
                    ),
                    if (state.filteredAirports.isNotEmpty)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                state.location.isLoaded
                                    ? 'Nearby Airports'
                                    : 'Search Results',
                                style: context.b1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
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
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          airport.code,
                                          style: context.b2,
                                        ),
                                        if (state.location.isLoaded)
                                          Text(
                                            ' • Nearby',
                                            style: context.b2.copyWith(
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                      ],
                                    ),
                                    onTap: () {
                                      locationController.text =
                                          '${airport.name}, ${airport.code}';
                                      context
                                          .read<LocationCubit>()
                                          .selectAirport(airport);
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<LocationCubit, LocationState>(
              listener: (context, state) {
                if (state.updateLocation.isLoaded) {
                  context.goNamed(AppRouteNames.homeScreen);
                } else if (state.updateLocation.isFailure) {
                  ToastHelper.showErrorToast(
                    state.updateLocation.errorMessage ??
                        'Failed to update location',
                  );
                }
              },
              builder: (context, state) {
                return FairwayButton(
                  borderRadius: 16,
                  onPressed: state.hasSelectedLocation
                      ? () => context.read<LocationCubit>().updateLocation()
                      : null,
                  text: 'Next',
                  textColor: AppColors.white,
                  disabled: !state.hasSelectedLocation,
                  isLoading: state.updateLocation.isLoading,
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
