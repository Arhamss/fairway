import 'package:dio/dio.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class RecentSearchesModel {
  const RecentSearchesModel({
    this.recentSearches = const [],
  });

  factory RecentSearchesModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchesModel(
      recentSearches: List<String>.from(json['recentSearches'] as List),
    );
  }
  final List<String> recentSearches;

  static ResponseModel<BaseApiResponse<RecentSearchesModel>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<BaseApiResponse<RecentSearchesModel>>(
      response,
      (json) => BaseApiResponse<RecentSearchesModel>.fromJson(
        json,
        RecentSearchesModel.fromJson,
      ),
    );
  }
}
