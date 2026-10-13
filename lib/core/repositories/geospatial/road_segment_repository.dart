import '../../models/geospatial/road_segment.dart';

abstract class RoadSegmentRepository {
  Future<List<RoadSegment>> getNearbyRoadSegments(double lat, double lon, double radiusMeters);
}
