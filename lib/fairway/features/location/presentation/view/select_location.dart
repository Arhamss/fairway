import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/features/location/data/models/terminal_model.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController airportController = TextEditingController();
  final TextEditingController terminalController = TextEditingController();
  final TextEditingController gateController = TextEditingController();
  Airport? previousAirport;

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().loadAirports();
    previousAirport = context.read<LocationCubit>().state.selectedAirport;
  }

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
          if (state.selectedAirport != previousAirport) {
            previousAirport = state.selectedAirport;
            if (state.selectedAirport != const Airport.empty()) {
              airportController.text =
                  '${state.selectedAirport.name}, ${state.selectedAirport.code}';
            } else {
              airportController.clear();
            }
          }

          if (state.updateLocation.isLoaded) {
            context.read<LocationCubit>().resetUpdateLocationState();
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
          if (state.location.isLoaded) {
            airportController.text =
                '${state.selectedAirport.name}, ${state.selectedAirport.code}';
            context.read<LocationCubit>().selectAirport(state.selectedAirport);
            FocusScope.of(context).unfocus();
          }

          if (state.updateLocation.isLoaded) {
            context.goNamed(AppRouteNames.homeScreen);
          }
        },
        builder: (context, state) {
          final isLoading = state.location.isLoading;
          final isAirportSelected =
              state.selectedAirport != const Airport.empty();
          final isTerminalSelected =
              state.selectedTerminal != const Terminal.empty();

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
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
                      FairwayDropDown(
                        labelText: 'Airport',
                        hintText: 'Search for airport',
                        controller: airportController,
                        displayKey: 'name',
                        prefixPath: AssetPaths.locationIcon,
                        dataLoader: () async {
                          return (state.airports.data?.airports ?? [])
                              .map(
                                (airport) => {
                                  'name': '${airport.name}, ${airport.code}',
                                  'code': airport.code,
                                  'airport': airport,
                                },
                              )
                              .toList();
                        },
                        onSelected: (selectedItem) {
                          final selectedAirport =
                              selectedItem['airport'] as Airport?;
                          if (selectedAirport != null) {
                            airportController.text =
                                '${selectedAirport.name}, ${selectedAirport.code}';
                            context
                                .read<LocationCubit>()
                                .selectAirport(selectedAirport);
                            FocusScope.of(context).unfocus();
                          }
                        },
                        onFieldTap: () {
                          terminalController.clear();
                          gateController.clear();
                          context.read<LocationCubit>().clearLocationState();
                        },
                      ),
                      if (isAirportSelected) ...[
                        if (!state.loadingTerminals) ...[
                          const SizedBox(height: 8),
                          FairwayDropDown(
                            labelText: 'Terminal',
                            controller: terminalController,
                            displayKey: 'name',
                            prefixPath: AssetPaths.terminalIcon,
                            dataLoader: () async {
                              return state.availableTerminals
                                  .map(
                                    (terminal) => {
                                      'name': terminal.name,
                                      'terminal': terminal,
                                    },
                                  )
                                  .toList();
                            },
                            onSelected: (selectedItem) {
                              final selectedTerminal =
                                  selectedItem['terminal'] as Terminal?;
                              if (selectedTerminal != null) {
                                terminalController.text = selectedTerminal.name;
                                context
                                    .read<LocationCubit>()
                                    .selectTerminal(selectedTerminal);
                                FocusScope.of(context).unfocus();
                              }
                            },
                            onFieldTap: () {
                              gateController.clear();
                              context
                                  .read<LocationCubit>()
                                  .clearTerminalSelection();
                            },
                          ),
                          if (isTerminalSelected) ...[
                            if (!state.loadingGates) ...[
                              const SizedBox(height: 8),
                              FairwayDropDown(
                                labelText: 'Gate',
                                controller: gateController,
                                displayKey: 'name',
                                prefixPath: AssetPaths.gateIcon,
                                dataLoader: () async {
                                  return state.availableGates
                                      .map(
                                        (gate) => {
                                          'name': gate,
                                          'gate': gate,
                                        },
                                      )
                                      .toList();
                                },
                                onSelected: (selectedItem) {
                                  final selectedGate =
                                      selectedItem['gate'] as String?;
                                  if (selectedGate != null) {
                                    gateController.text = selectedGate;
                                    context
                                        .read<LocationCubit>()
                                        .selectGate(selectedGate);
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                onFieldTap: () {
                                  context
                                      .read<LocationCubit>()
                                      .clearGateLocationState();
                                },
                              ),
                            ] else
                              const Padding(
                                padding: EdgeInsets.only(top: 24),
                                child: Center(child: LoadingWidget()),
                              ),
                          ],
                        ] else
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Center(child: LoadingWidget()),
                          ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              final allSelected =
                  state.selectedAirport != const Airport.empty() &&
                      state.selectedTerminal != const Terminal.empty();
              return FairwayButton(
                borderRadius: 16,
                onPressed: allSelected
                    ? () {
                        context.read<LocationCubit>().updateLocation();
                      }
                    : null,
                text: 'Save',
                textColor: AppColors.white,
                disabled: !allSelected,
                isLoading: state.updateLocation.isLoading,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    airportController.dispose();
    terminalController.dispose();
    gateController.dispose();
    super.dispose();
  }
}
