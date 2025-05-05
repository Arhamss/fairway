import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/constants/constants.dart';

enum SortByOption {
  unselected,
  recommended,
  mostPopular,
}

extension SortByOptionExtension on SortByOption {
  String get label {
    switch (this) {
      case SortByOption.unselected:
        return 'Select Option';
      case SortByOption.recommended:
        return 'Recommended';
      case SortByOption.mostPopular:
        return 'Most Popular';
    }
  }

  String get toName {
    switch (this) {
      case SortByOption.unselected:
        return ' ';
      case SortByOption.recommended:
        return 'recommended';
      case SortByOption.mostPopular:
        return 'mostPopular';
    }
  }

  String get asset {
    switch (this) {
      case SortByOption.unselected:
        return AssetPaths.filterIcon; // Add a default sort icon to your assets
      case SortByOption.recommended:
        return AssetPaths.recommendedIcon;
      case SortByOption.mostPopular:
        return AssetPaths.mostPopularIcon;
    }
  }

  String get backendValue {
    switch (this) {
      case SortByOption.unselected:
        return '';
      case SortByOption.recommended:
        return 'true';
      case SortByOption.mostPopular:
        return 'false';
    }
  }

  bool get isSelected => this != SortByOption.unselected;
}
