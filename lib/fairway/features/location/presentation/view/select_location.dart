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
  final TextEditingController airportController = TextEditingController();
  final TextEditingController terminalController = TextEditingController();
  final TextEditingController gateController = TextEditingController();

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
          if (state.location.isLoaded) {
            airportController.text =
                '${state.selectedAirport!.name}, ${state.selectedAirport!.code}';
            context.read<LocationCubit>().selectAirport(state.selectedAirport);
            FocusScope.of(context).unfocus();
          }

          if (state.updateLocation.isLoaded) {
            context.read<LocationCubit>().setCurrentLocation();
          }

          if (state.setCurrentLocation.isLoaded) {
            context.goNamed(AppRouteNames.homeScreen);
          }
          if (state.setCurrentLocation.isFailure) {
            ToastHelper.showErrorToast(
              state.setCurrentLocation.errorMessage ?? 'Failed to set location',
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.location.isLoading;
          final isAirportSelected = state.selectedAirport != null;
          final isTerminalSelected = state.selectedTerminal != null;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Initial setup screen
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

                      // Airport search field
                      FairwayTextField(
                        type: FairwayTextFieldType.location,
                        hintText: 'Search for airport',
                        controller: airportController,
                        onChanged: (value) => context
                            .read<LocationCubit>()
                            .onLocationInput(value),
                        onClear: () {
                          airportController.clear(); // Clear the text field
                          terminalController
                              .clear(); // Clear terminal field too
                          gateController.clear(); // Clear gate field too
                          context.read<LocationCubit>().clearLocationState();
                        },
                        readOnly: isAirportSelected,
                      ),

                      // Airport search results - only shown when typing
                      if (!isAirportSelected &&
                          airportController.text.isNotEmpty &&
                          state.filteredAirports.isNotEmpty)
                        // Replace Expanded with a SizedBox
                        SizedBox(
                          height: 300, // Fixed height instead of Expanded
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
                                    final airport =
                                        state.filteredAirports[index];
                                    return ListTile(
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                        airportController.text =
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

                      // Selected Airport Container and fields for terminal/gate
                      if (isAirportSelected) ...[
                        // Terminal selection
                        if (!state.loadingTerminals) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Terminal',
                            style: context.b1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          FairwayTextField(
                            type: FairwayTextFieldType.location,
                            hintText: 'Search for terminal',
                            controller: terminalController,
                            onChanged: (value) => context
                                .read<LocationCubit>()
                                .onTerminalInput(value),
                            onClear: () {
                              terminalController
                                  .clear(); // Clear the text field
                              gateController.clear(); // Clear gate field too
                              context
                                  .read<LocationCubit>()
                                  .clearTerminalSelection();
                            },
                            readOnly: isTerminalSelected,
                          ),

                          // Terminal search results - only when typing
                          if (!isTerminalSelected &&
                              terminalController.text.isNotEmpty &&
                              state.filteredTerminals.isNotEmpty)
                            _buildSearchResults(
                              context,
                              title: 'Matching Terminals',
                              items: state.filteredTerminals
                                  .map((terminal) => terminal.name)
                                  .toList(),
                              onItemSelected: (index) {
                                final terminal = state.filteredTerminals[index];
                                terminalController.text = terminal.name;
                                context
                                    .read<LocationCubit>()
                                    .selectTerminal(terminal);
                                FocusScope.of(context).unfocus();
                              },
                            ),

                          // Show all terminals if not filtered
                          if (!isTerminalSelected &&
                              terminalController.text.isEmpty &&
                              state.availableTerminals.isNotEmpty)
                            _buildSearchResults(
                              context,
                              title: 'Available Terminals',
                              items: state.availableTerminals
                                  .map((terminal) => terminal.name)
                                  .toList(),
                              onItemSelected: (index) {
                                final terminal =
                                    state.availableTerminals[index];
                                terminalController.text = terminal.name;
                                context
                                    .read<LocationCubit>()
                                    .selectTerminal(terminal);
                                FocusScope.of(context).unfocus();
                              },
                            ),

                          // Terminal selected, show gate selection
                          if (isTerminalSelected) ...[
                            // Gate selection
                            if (!state.loadingGates) ...[
                              const SizedBox(height: 24),
                              Text(
                                'Gate',
                                style: context.b1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 12),
                              FairwayTextField(
                                type: FairwayTextFieldType.location,
                                hintText: 'Search for gate',
                                controller: gateController,
                                onChanged: (value) => context
                                    .read<LocationCubit>()
                                    .onGateInput(value),
                                onClear: () {
                                  gateController
                                      .clear(); // Clear the text field
                                  context
                                      .read<LocationCubit>()
                                      .clearGateLocationState();
                                },
                                readOnly: state.selectedTerminal != null,
                              ),

                              // Gate search results - only when typing
                              if (state.selectedGate == null &&
                                  gateController.text.isNotEmpty &&
                                  state.filteredGates.isNotEmpty)
                                _buildSearchResults(
                                  context,
                                  title: 'Matching Gates',
                                  items: state.filteredGates,
                                  onItemSelected: (index) {
                                    final gate = state.filteredGates[index];
                                    gateController.text = gate;
                                    context
                                        .read<LocationCubit>()
                                        .selectGate(gate);
                                    FocusScope.of(context).unfocus();
                                  },
                                ),

                              // Show all gates if not filtered
                              if (state.selectedGate == null &&
                                  gateController.text.isEmpty &&
                                  state.availableGates.isNotEmpty)
                                _buildSearchResults(
                                  context,
                                  title: 'Available Gates',
                                  items: state.availableGates,
                                  onItemSelected: (index) {
                                    final gate = state.availableGates[index];
                                    gateController.text = gate;
                                    context
                                        .read<LocationCubit>()
                                        .selectGate(gate);
                                    FocusScope.of(context).unfocus();
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

  // Reusable widget for search results with fixed height instead of Expanded
  Widget _buildSearchResults(
    BuildContext context, {
    required String title,
    required List<String> items,
    required Function(int) onItemSelected,
  }) {
    return SizedBox(
      height: 200,
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
              title,
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
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: Text(
                    items[index],
                    style: context.b1.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom navigation bar
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              final allSelected = state.selectedAirport != null &&
                  state.selectedTerminal != null;
              return FairwayButton(
                borderRadius: 16,
                onPressed: allSelected
                    ? () => context.read<LocationCubit>().updateLocation()
                    : null,
                text: 'Next',
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
