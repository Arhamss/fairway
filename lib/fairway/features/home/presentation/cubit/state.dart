import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class HomeState extends Equatable {
  const HomeState({
    this.userProfile = const DataState.initial(),
    this.isFilterExpanded = false,
    this.selectedTabIndex = 0,
  });

  final DataState<UserModel> userProfile;
  final bool isFilterExpanded;
  final int selectedTabIndex;
  

  HomeState copyWith({
    DataState<UserModel>? userProfile,
    bool? isFilterExpanded,
    int? selectedTabIndex,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      isFilterExpanded: isFilterExpanded ?? this.isFilterExpanded,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        isFilterExpanded,
        selectedTabIndex,
      ];
}
