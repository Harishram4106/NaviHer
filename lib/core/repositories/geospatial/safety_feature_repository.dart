import '../../models/geospatial/safety_feature.dart';

abstract class SafetyFeatureRepository {
  Future<List<SafetyFeature>> getForRoadSegment(String roadSegmentId);
}
