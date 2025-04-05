import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  int? _selectedIndex;

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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ...List.generate(locations.length, (index) {
                  final loc = locations[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.greyShade5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.terminal,
                                  style: context.b1.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${loc.airportName}, ${loc.airportCode}',
                                  style: context.b2.copyWith(
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: AppColors.primaryBlue),
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
                const Spacer(),
                FairwayButton(
                  text: 'Submit',
                  onPressed: _selectedIndex != null
                      ? () {
                          final selected = locations[_selectedIndex!];

                          AppLogger.info(
                            'Selected Location: ${selected.toJson()}',
                          );
                        }
                      : null,
                  isLoading: false,
                  textColor: AppColors.white,
                  borderRadius: 16,
                  fontWeight: FontWeight.w600,
                  outsidePadding: const EdgeInsets.symmetric(vertical: 16),
                  disabled: _selectedIndex == null,
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
