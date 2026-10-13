import 'package:uuid/uuid.dart';

import '../../models/route_model.dart';
import '../../models/geospatial/coordinate_utils.dart';
import '../../models/geospatial/road_segment.dart';
import '../../models/geospatial/safety_feature.dart';
import '../navigation_repository.dart';
import '../geospatial/hazard_repository.dart';
import '../geospatial/community_report_repository.dart';
import '../../../features/navigation/services/routing_engine.dart';
import '../../../features/safety/services/safety_intelligence_engine.dart';
import '../../../features/safety/services/safety_signal_aggregator.dart';

/// MOCK — NaviHer Navigation Repository
/// Dynamically calculates routes using the RoutingEngine and mock data.
class MockNavigationRepository implements NavigationRepository {
  final HazardRepository _hazardRepo;
  final CommunityReportRepository _reportRepo;
  final RoutingEngine _engine = RoutingEngine();
  final SafetyIntelligenceEngine _safetyEngine = SafetyIntelligenceEngine();
  final SafetySignalAggregator _aggregator = SafetySignalAggregator();
  final Map<String, SafetyFeature> _baseSafetyFeatures = {};
  final List<RoadSegment> _segments = [];
  
  String? _segACId;

  MockNavigationRepository(this._hazardRepo, this._reportRepo) {
    _initializeMockGraph();
  }

  void _initializeMockGraph() {
    const uuid = Uuid();
    // Create a simple diamond graph structure to test fastest vs safest.
    // Node A (Origin) -> Node B -> Node D (Dest) = Fastest but dangerous
    // Node A (Origin) -> Node C -> Node D (Dest) = Longer but very safe
    final coordA = const Coordinate(latitude: 37.7749, longitude: -122.4194);
    final coordB = const Coordinate(latitude: 37.7760, longitude: -122.4170); // Risky
    final coordC = const Coordinate(latitude: 37.7730, longitude: -122.4170); // Safe
    final coordD = const Coordinate(latitude: 37.7750, longitude: -122.4150); // Dest

    // Segment A -> B (Fast but risky)
    final segABId = uuid.v4();
    final segAB = RoadSegment(
      id: segABId,
      name: 'Fast Lane',
      geometry: [coordA, coordB],
      lengthMeters: 500,
      estimatedTravelTimeSeconds: 60,
    );
    _segments.add(segAB);
    _baseSafetyFeatures[segABId] = SafetyFeature(
      id: uuid.v4(),
      roadSegmentId: segABId,
      lightingScore: 10,
      isolationScore: 80,
      activityScore: 5,
      hazardScore: 40,
    );

    // Segment B -> D
    final segBDId = uuid.v4();
    final segBD = RoadSegment(
      id: segBDId,
      name: 'Dark Alley',
      geometry: [coordB, coordD],
      lengthMeters: 500,
      estimatedTravelTimeSeconds: 60,
    );
    _segments.add(segBD);
    _baseSafetyFeatures[segBDId] = SafetyFeature(
      id: uuid.v4(),
      roadSegmentId: segBDId,
      lightingScore: 5,
      isolationScore: 90,
      activityScore: 0,
      hazardScore: 30,
    );

    // Segment A -> C (Slower but very safe initially)
    _segACId = uuid.v4();
    final segAC = RoadSegment(
      id: _segACId!,
      name: 'Main Street',
      geometry: [coordA, coordC],
      lengthMeters: 800,
      estimatedTravelTimeSeconds: 150,
    );
    _segments.add(segAC);
    _baseSafetyFeatures[_segACId!] = SafetyFeature(
      id: uuid.v4(),
      roadSegmentId: _segACId!,
      lightingScore: 95,
      isolationScore: 10,
      activityScore: 90,
      hazardScore: 0, // Will be updated dynamically
      riskSignalScore: 0, // Will be updated dynamically
    );

    // Segment C -> D
    final segCDId = uuid.v4();
    final segCD = RoadSegment(
      id: segCDId,
      name: 'Market Blvd',
      geometry: [coordC, coordD],
      lengthMeters: 800,
      estimatedTravelTimeSeconds: 150,
    );
    _segments.add(segCD);
    _baseSafetyFeatures[segCDId] = SafetyFeature(
      id: uuid.v4(),
      roadSegmentId: segCDId,
      lightingScore: 100,
      isolationScore: 5,
      activityScore: 95,
      hazardScore: 0,
    );

    _engine.buildGraph(_segments);
  }

  @override
  Future<List<RouteModel>> getRoutes({
    required String from,
    required String to,
    required RouteTravelMode mode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Dynamic Hazard Aggregation
    // Create a dynamic snapshot of the features
    final dynamicFeatures = Map<String, SafetyFeature>.from(_baseSafetyFeatures);

    // For deterministic mock, we specifically query for segAC which now has dynamic hazards
    if (_segACId != null) {
      final hazards = await _hazardRepo.getHazardsForSegment(_segACId!);
      final reports = await _reportRepo.getReportsForSegment(_segACId!);
      
      final (dynamicHazardScore, dynamicRiskScore) = _aggregator.aggregateSignals(
        hazards: hazards, 
        reports: reports
      );

      // Overwrite the base score with dynamic aggregated score
      dynamicFeatures[_segACId!] = dynamicFeatures[_segACId!]!.copyWith(
        hazardScore: dynamicHazardScore,
        riskSignalScore: dynamicRiskScore,
      );
    }

    // For mock demonstration, always use the predefined endpoints of our diamond graph
    final origin = const Coordinate(latitude: 37.7749, longitude: -122.4194);
    final dest = const Coordinate(latitude: 37.7750, longitude: -122.4150);

    final fastestSegments = _engine.findFastestRoute(origin, dest);
    final safestSegments = _engine.findSafestRoute(origin, dest, dynamicFeatures, _safetyEngine);

    final routes = <RouteModel>[];

    if (safestSegments != null) {
      routes.add(_buildRouteModel(
        segments: safestSegments,
        features: dynamicFeatures,
        id: 'naviher-safe-001',
        name: 'NaviHer Safe Route',
        type: RoutePreference.naviherSafe,
      ));
    }

    if (fastestSegments != null) {
      routes.add(_buildRouteModel(
        segments: fastestSegments,
        features: dynamicFeatures,
        id: 'fastest-001',
        name: 'Fastest Route',
        type: RoutePreference.fastest,
      ));
    }

    return routes;
  }

  RouteModel _buildRouteModel({
    required List<RoadSegment> segments,
    required Map<String, SafetyFeature> features,
    required String id,
    required String name,
    required RoutePreference type,
  }) {
    double totalDistance = 0;
    int totalTime = 0;
    final polyline = <LatLng>[];

    // Compute basic totals
    for (final seg in segments) {
      totalDistance += (seg.lengthMeters ?? 0) / 1000.0;
      totalTime += seg.estimatedTravelTimeSeconds ?? 0;
      
      for (final coord in seg.geometry) {
        // avoid consecutive duplicates in polyline
        if (polyline.isNotEmpty && 
            polyline.last.lat == coord.latitude && 
            polyline.last.lng == coord.longitude) {
          continue;
        }
        polyline.add(LatLng(coord.latitude, coord.longitude));
      }
    }

    final explanation = _safetyEngine.generateExplanation(segments, features);
    
    final factors = <SafetyFactor>[
      ...explanation.positiveFactors,
      ...explanation.negativeFactors,
    ];

    return RouteModel(
      id: id,
      name: name,
      durationMinutes: (totalTime / 60).ceil(),
      distanceKm: double.parse(totalDistance.toStringAsFixed(1)),
      safetyScore: explanation.overallSafetyScore,
      safetyFactors: factors,
      type: type,
      polyline: polyline,
    );
  }

  @override
  Future<NavigationSession?> getActiveSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final routes = await getRoutes(from: '', to: '', mode: RouteTravelMode.alone);
    
    return NavigationSession(
      activeRoute: routes.first,
      currentInstruction: const NavigationInstruction(
        direction: 'Turn right',
        streetName: 'Main Street',
        distanceMeters: 300,
        iconAsset: 'turn_right',
      ),
      etaMinutes: routes.first.durationMinutes,
      remainingKm: routes.first.distanceKm,
      isActive: true,
    );
  }
}

