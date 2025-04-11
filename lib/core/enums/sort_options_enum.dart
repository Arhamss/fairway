import 'package:fairway/constants/asset_paths.dart';

enum SortByOption {
  recommended,
  mostPopular,
}

extension SortByOptionExtension on SortByOption {
  String get label {
    switch (this) {
      case SortByOption.recommended:
        return 'Recommended';
      case SortByOption.mostPopular:
        return 'Most Popular';
    }
  }

  String get asset {
    switch (this) {
      case SortByOption.recommended:
        return AssetPaths.recommendedIcon;
      case SortByOption.mostPopular:
        return AssetPaths.mostPopularIcon;
    }
  }

  String get backendValue {
    switch (this) {
      case SortByOption.recommended:
        return 'recommended';
      case SortByOption.mostPopular:
        return 'most_popular';
    }
  }
}
