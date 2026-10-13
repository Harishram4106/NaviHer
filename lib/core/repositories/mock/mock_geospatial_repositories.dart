import '../../models/geospatial/coordinate_utils.dart';
import '../../models/geospatial/road_segment.dart';
import '../../models/geospatial/safety_feature.dart';
import '../../models/geospatial/point_of_interest.dart';
import '../../models/geospatial/hazard.dart';
import '../../models/geospatial/community_report.dart';

import '../geospatial/road_segment_repository.dart';
import '../geospatial/safety_feature_repository.dart';
import '../geospatial/point_of_interest_repository.dart';
import '../geospatial/hazard_repository.dart';
import '../geospatial/community_report_repository.dart';

class MockRoadSegmentRepository implements RoadSegmentRepository {
  @override
  Future<List<RoadSegment>> getNearbyRoadSegments(double lat, double lon, double radiusMeters) async {
    return [
      RoadSegment(
        id: 'mock-road-1',
        name: 'Mock Market St',
        geometry: const [
          Coordinate(latitude: 37.7879, longitude: -122.4031),
          Coordinate(latitude: 37.7898, longitude: -122.4005),
        ],
        lengthMeters: 350,
        estimatedTravelTimeSeconds: 45,
        isDemo: true,
      ),
    ];
  }
}

class MockSafetyFeatureRepository implements SafetyFeatureRepository {
  @override
  Future<List<SafetyFeature>> getForRoadSegment(String roadSegmentId) async {
    return [
      SafetyFeature(
        id: 'mock-sf-1',
        roadSegmentId: roadSegmentId,
        lightingScore: 85,
        activityScore: 90,
        emergencyAccessScore: 80,
        openBusinessScore: 95,
        roadQualityScore: 75,
        isolationScore: 10,
        hazardScore: 5,
        riskSignalScore: 10,
        confidence: 92,
        isDemo: true,
      ),
    ];
  }
}

class MockPointOfInterestRepository implements PointOfInterestRepository {
  @override
  Future<List<PointOfInterest>> getNearbyPointsOfInterest(double lat, double lon, double radiusMeters) async {
    return [
      PointOfInterest(
        id: 'mock-poi-1',
        name: 'Mock Hospital',
        category: 'hospital',
        location: const Coordinate(latitude: 37.7890, longitude: -122.4045),
        isDemo: true,
      ),
    ];
  }
}

class MockHazardRepository implements HazardRepository {
  @override
  Future<List<Hazard>> getHazardsForSegment(String roadSegmentId) async {
    // If it's the specific "segAC" (Main Street, the previously safe one), add a hazard
    // We don't have the exact ID here unless we match it, but MockNavigationRepository will pass it.
    // For deterministic testing, we return a hazard for ANY segment queried for hazards, 
    // but in practice MockNavigationRepository will only query it.
    // Wait, it's better to just return an active hazard. 
    return [
      Hazard(
        id: 'mock-haz-1',
        roadSegmentId: roadSegmentId,
        category: 'flooding',
        severity: 75,
        confidence: 90,
        description: 'Mock severe flooding',
        location: const Coordinate(latitude: 37.7880, longitude: -122.3995),
        status: HazardStatus.active,
        reportedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        isDemo: true,
      ),
    ];
  }
}

class MockCommunityReportRepository implements CommunityReportRepository {
  @override
  Future<List<CommunityReport>> getReportsForSegment(String roadSegmentId) async {
    // Return 3 recent reports to corroborate danger
    return [
      CommunityReport(
        id: 'mock-rep-1',
        roadSegmentId: roadSegmentId,
        category: 'unsafe_area',
        description: 'Feeling unsafe here right now',
        confidence: 90,
        location: const Coordinate(latitude: 37.7882, longitude: -122.4025),
        moderationStatus: ModerationStatus.approved,
        reportedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isDemo: true,
      ),
      CommunityReport(
        id: 'mock-rep-2',
        roadSegmentId: roadSegmentId,
        category: 'suspicious_activity',
        description: 'Group of people loitering',
        confidence: 85,
        location: const Coordinate(latitude: 37.7883, longitude: -122.4026),
        moderationStatus: ModerationStatus.approved,
        reportedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        isDemo: true,
      ),
    ];
  }

  @override
  Future<CommunityReport> createReport(CommunityReport report) async {
    return report;
  }
}
