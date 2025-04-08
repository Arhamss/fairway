import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class HomeState extends Equatable {
  const HomeState({
    this.userProfile = const DataState.initial(),
    this.isFilterExpanded = false,
    this.selectedTabIndex = 0,
    this.selectedFilter = 'Nearby',
  });

  final DataState<UserModel> userProfile;
  final bool isFilterExpanded;
  final int selectedTabIndex;
  final String selectedFilter;

  HomeState copyWith({
    DataState<UserModel>? userProfile,
    bool? isFilterExpanded,
    int? selectedTabIndex,
    String? selectedFilter,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      isFilterExpanded: isFilterExpanded ?? this.isFilterExpanded,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        isFilterExpanded,
        selectedTabIndex,
        selectedFilter,
      ];
}
