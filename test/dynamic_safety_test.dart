import 'package:flutter_test/flutter_test.dart';
import 'package:naviher_ai/core/models/geospatial/hazard.dart';
import 'package:naviher_ai/core/models/geospatial/community_report.dart';
import 'package:naviher_ai/core/models/geospatial/coordinate_utils.dart';
import 'package:naviher_ai/features/safety/services/safety_signal_aggregator.dart';

void main() {
  group('Dynamic Safety & Signal Aggregation Tests', () {
    final aggregator = SafetySignalAggregator();
    final dummyLocation = Coordinate(latitude: 0.0, longitude: 0.0);

    test('Aggregate signals when no active hazards or reports', () {
      final (hazardScore, riskScore) = aggregator.aggregateSignals(hazards: [], reports: []);
      
      expect(hazardScore, 0.0);
      expect(riskScore, 0.0);
    });

    test('Aggregate signals with a hazard adds to hazardScore', () {
      final hazards = [
        Hazard(
          id: 'h1',
          location: dummyLocation,
          roadSegmentId: 'seg1',
          category: 'poorLighting',
          status: HazardStatus.active,
          severity: 80.0,
          confidence: 100.0,
          reportedAt: DateTime.now(),
        ),
      ];

      final (hazardScore, riskScore) = aggregator.aggregateSignals(hazards: hazards, reports: []);
      
      expect(hazardScore, 80.0);
      expect(riskScore, 0.0);
    });

    test('Aggregate signals with multiple reports and hazards', () {
      final hazards = [
        Hazard(
          id: 'h1',
          location: dummyLocation,
          roadSegmentId: 'seg1',
          category: 'suspiciousActivity',
          status: HazardStatus.active,
          severity: 50.0,
          confidence: 100.0,
          reportedAt: DateTime.now(),
        ),
      ];

      final reports = [
        CommunityReport(
          id: 'r1',
          location: dummyLocation,
          userId: 'u1',
          roadSegmentId: 'seg1',
          category: 'harassment',
          confidence: 100.0,
          reportedAt: DateTime.now(),
        ),
        CommunityReport(
          id: 'r2',
          location: dummyLocation,
          userId: 'u2',
          roadSegmentId: 'seg1',
          category: 'harassment',
          confidence: 100.0,
          reportedAt: DateTime.now().subtract(const Duration(hours: 25)),
        ),
      ];

      final (hazardScore, riskScore) = aggregator.aggregateSignals(hazards: hazards, reports: reports);
      
      expect(hazardScore, 50.0);
      // r1 = 15.0 (recent), r2 = 7.5 (older than 24h) => 22.5
      expect(riskScore, 22.5);
    });
  });
}
