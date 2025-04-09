import 'package:dio/dio.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';

class SearchSuggestionsModel {
  const SearchSuggestionsModel({
    this.totalResults = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.suggestions = const [],
  });

  factory SearchSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionsModel(
      totalResults: json['totalResults'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      suggestions: (json['suggestions'] as List?)
              ?.map((e) => SuggestionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final int totalResults;
  final int totalPages;
  final int currentPage;
  final List<SuggestionItem> suggestions;

  static ResponseModel<BaseApiResponse<SearchSuggestionsModel>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<
        BaseApiResponse<SearchSuggestionsModel>>(
      response,
      (json) => BaseApiResponse<SearchSuggestionsModel>.fromJson(
        json,
        SearchSuggestionsModel.fromJson,
      ),
    );
  }
}

class SuggestionItem {
  const SuggestionItem({
    required this.id,
    required this.name,
    required this.website,
    required this.images,
    required this.airport,
    required this.categories,
    required this.bestPartner,
    required this.recommended,
    required this.popularity,
    required this.createdAt,
  });

  factory SuggestionItem.fromJson(Map<String, dynamic> json) {
    return SuggestionItem(
      id: json['id'] as String,
      name: json['name'] as String,
      website: json['website'] as String? ?? '',
      images: json['images'] as String? ?? '',
      airport: Airport.fromJson(json['airport'] as Map<String, dynamic>),
      categories: (json['categories'] as List?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bestPartner: json['bestPartner'] as bool? ?? false,
      recommended: json['recommended'] as bool? ?? false,
      popularity: json['popularity'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String name;
  final String website;
  final String images;
  final Airport airport;
  final List<Category> categories;
  final bool bestPartner;
  final bool recommended;
  final int popularity;
  final DateTime createdAt;
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.picture,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      picture: json['picture'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String picture;
}
