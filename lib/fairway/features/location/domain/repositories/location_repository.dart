import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class LocationRepository {
  Future<RepositoryResponse<UserData>> updateUserLocation(
    String location,
  );

  Future<RepositoryResponse<LocationData>> getAirports({
    required int page,
    required int limit,
    String? query,
    String? code,
    double? lat,
    double? long,
  });
}
