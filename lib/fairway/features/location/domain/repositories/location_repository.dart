import 'package:fairway/fairway/features/location/data/models/airport_request_model.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/models/saved_location_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class LocationRepository {
  Future<RepositoryResponse<bool>> updateUserLocation(
    AirportRequestModel location,
  );

  Future<RepositoryResponse<bool>> setCurrentLocation(
    AirportRequestModel location,
  );

  Future<RepositoryResponse<LocationData>> getAirports({
    required int page,
    required int limit,
    String? query,
    String? code,
    double? lat,
    double? long,
  });

  Future<RepositoryResponse<LocationData>> getAirportsByLatLong({
    required double lat,
    required double long,
  });
}
