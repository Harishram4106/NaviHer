import 'package:flutter_test/flutter_test.dart';
import 'package:naviher_ai/core/models/geospatial/safety_feature.dart';
import 'package:naviher_ai/core/models/geospatial/road_segment.dart';
import 'package:naviher_ai/core/models/geospatial/coordinate_utils.dart';
import 'package:naviher_ai/features/safety/services/safety_intelligence_engine.dart';

void main() {
  group('SafetyIntelligenceEngine Tests', () {
    late SafetyIntelligenceEngine engine;

    setUp(() {
      engine = SafetyIntelligenceEngine();
    });

    test('evaluateSegmentSafety calculates correct baseline for null feature', () {
      final score = engine.evaluateSegmentSafety(null);
      expect(score, equals(50.0));
    });

    test('evaluateSegmentSafety calculates correct score for perfectly safe segment', () {
      final feature = SafetyFeature(
        id: '1',
        roadSegmentId: 'seg1',
        lightingScore: 100,
        activityScore: 100,
        emergencyAccessScore: 100,
        openBusinessScore: 100,
        roadQualityScore: 100,
        isolationScore: 0,
        hazardScore: 0,
        riskSignalScore: 0,
      );

      final score = engine.evaluateSegmentSafety(feature);
      expect(score, equals(100.0));
    });

    test('evaluateSegmentSafety calculates correct score for risky segment', () {
      final feature = SafetyFeature(
        id: '1',
        roadSegmentId: 'seg1',
        lightingScore: 0,
        activityScore: 0,
        emergencyAccessScore: 0,
        openBusinessScore: 0,
        roadQualityScore: 0,
        isolationScore: 100,
        hazardScore: 100,
        riskSignalScore: 100,
      );

      final score = engine.evaluateSegmentSafety(feature);
      expect(score, equals(0.0));
    });

    test('evaluateSegmentCost maps safety correctly', () {
      final safeFeature = SafetyFeature(id: '1', roadSegmentId: 'seg1', lightingScore: 100, activityScore: 100, emergencyAccessScore: 100, openBusinessScore: 100, roadQualityScore: 100, isolationScore: 0, hazardScore: 0, riskSignalScore: 0);
      final riskyFeature = SafetyFeature(id: '2', roadSegmentId: 'seg2', lightingScore: 0, activityScore: 0, emergencyAccessScore: 0, openBusinessScore: 0, roadQualityScore: 0, isolationScore: 100, hazardScore: 100, riskSignalScore: 100);
      
      expect(engine.evaluateSegmentCost(safeFeature), equals(0.5));
      expect(engine.evaluateSegmentCost(riskyFeature), equals(2.5));
      expect(engine.evaluateSegmentCost(null), equals(1.5));
    });

    test('generateExplanation builds appropriate route factors', () {
      final seg1 = RoadSegment(id: 's1', name: 'Safe Road', geometry: [const Coordinate(latitude: 0, longitude: 0)], lengthMeters: 10, estimatedTravelTimeSeconds: 10);
      final seg2 = RoadSegment(id: 's2', name: 'Safe Road 2', geometry: [const Coordinate(latitude: 0, longitude: 0)], lengthMeters: 10, estimatedTravelTimeSeconds: 10);
      
      final features = {
        's1': SafetyFeature(id: 'f1', roadSegmentId: 's1', lightingScore: 100, activityScore: 90, isolationScore: 0, hazardScore: 0),
        's2': SafetyFeature(id: 'f2', roadSegmentId: 's2', lightingScore: 80, activityScore: 80, isolationScore: 10, hazardScore: 0),
      };
      
      final explanation = engine.generateExplanation([seg1, seg2], features);
      
      expect(explanation.positiveFactors, isNotEmpty);
      expect(explanation.positiveFactors.any((f) => f.label.contains('Well-lit')), isTrue);
      expect(explanation.positiveFactors.any((f) => f.label.contains('High public activity')), isTrue);
      expect(explanation.negativeFactors, isEmpty);
    });
  });
}
