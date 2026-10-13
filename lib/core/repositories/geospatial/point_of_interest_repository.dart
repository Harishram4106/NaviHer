import '../../models/geospatial/point_of_interest.dart';

abstract class PointOfInterestRepository {
  Future<List<PointOfInterest>> getNearbyPointsOfInterest(double lat, double lon, double radiusMeters);
}
