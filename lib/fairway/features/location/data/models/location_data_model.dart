import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class LocationData extends Equatable {
  const LocationData({
    required this.airports,
    this.totalResults = 0,
    this.totalPages = 0,
    this.currentPage = 0,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      return LocationData(
        airports: [Airport.fromJson(json)],
        totalResults: 1,
        totalPages: 1,
        currentPage: 1,
      );
    }

    final airportsJson = json['airports'] as List<dynamic>? ?? [];

    return LocationData(
      airports: airportsJson
          .map<Airport>(
            (airport) => Airport.fromJson(airport as Map<String, dynamic>),
          )
          .toList(),
      totalResults: json['totalResults'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 0,
    );
  }

  static ResponseModel<BaseApiResponse<LocationData>> parseResponse(
      Response response) {
    return ResponseModel.fromApiResponse<BaseApiResponse<LocationData>>(
      response,
      (json) =>
          BaseApiResponse<LocationData>.fromJson(json, LocationData.fromJson),
    );
  }

  final List<Airport> airports;
  final int totalResults;
  final int totalPages;
  final int currentPage;

  @override
  List<Object?> get props => [airports, totalResults, totalPages, currentPage];
}
