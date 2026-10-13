import '../../models/geospatial/hazard.dart';

abstract class HazardRepository {
  Future<List<Hazard>> getHazardsForSegment(String roadSegmentId);
}
