import '../../../core/models/geospatial/safety_feature.dart';
import '../../../core/models/geospatial/road_segment.dart';
import '../../../core/models/route_model.dart';

class RouteExplanation {
  final int overallSafetyScore; // 0-100
  final List<SafetyFactor> positiveFactors;
  final List<SafetyFactor> negativeFactors;
  final double? confidence;
  final DateTime? freshness;
  
  RouteExplanation({
    required this.overallSafetyScore,
    required this.positiveFactors,
    required this.negativeFactors,
    this.confidence,
    this.freshness,
  });
}

class SafetyIntelligenceEngine {
  /// Evaluates segment safety returning a normalized score 0-100.
  /// Higher means safer.
  double evaluateSegmentSafety(SafetyFeature? feature) {
    if (feature == null) return 50.0; // Default unknown is neutral

    // Positive signals (0-100)
    final lighting = feature.lightingScore ?? 50.0;
    final activity = feature.activityScore ?? 50.0;
    final emergencyAccess = feature.emergencyAccessScore ?? 50.0;
    final openBusiness = feature.openBusinessScore ?? 50.0;
    final roadQuality = feature.roadQualityScore ?? 50.0;

    // Negative signals (0-100) -> Higher value means MORE risk
    final isolation = feature.isolationScore ?? 0.0;
    final hazards = feature.hazardScore ?? 0.0;
    final riskSignals = feature.riskSignalScore ?? 0.0;

    // Averages
    final positiveAvg = (lighting + activity + emergencyAccess + openBusiness + roadQuality) / 5.0;
    final negativeAvg = (isolation + hazards + riskSignals) / 3.0;

    // Formula: Start at 50, add positive benefits, subtract negative risks
    double score = 50.0 + (positiveAvg * 0.5) - (negativeAvg * 0.5);

    return score.clamp(0.0, 100.0);
  }

  /// Calculates a cost multiplier (penalty) for Dijkstra.
  /// Higher penalty = more dangerous/costly. Floor is 0.5.
  double evaluateSegmentCost(SafetyFeature? feature) {
    final safetyScore = evaluateSegmentSafety(feature);
    
    // Invert the score: 100 (Safe) -> 0.5 penalty, 0 (Risky) -> 2.5 penalty
    // Linear mapping: 50 -> 1.5
    double penalty = 2.5 - (safetyScore * 0.02); 
    
    return penalty.clamp(0.5, 3.0);
  }

  /// Generates the explanation based on actual segment data in the route.
  RouteExplanation generateExplanation(
    List<RoadSegment> route, 
    Map<String, SafetyFeature> features
  ) {
    if (route.isEmpty) {
      return RouteExplanation(
        overallSafetyScore: 50,
        positiveFactors: [],
        negativeFactors: [],
      );
    }

    double totalScore = 0;
    
    double avgLighting = 0;
    double avgActivity = 0;
    double avgEmergency = 0;
    double avgIsolation = 0;
    double maxHazard = 0;
    double minConfidence = 100;
    bool hasConfidence = false;
    DateTime? minFreshness;
    
    int dataPoints = 0;

    for (final seg in route) {
      final feature = features[seg.id];
      totalScore += evaluateSegmentSafety(feature);
      
      if (feature != null) {
        dataPoints++;
        avgLighting += feature.lightingScore ?? 50;
        avgActivity += feature.activityScore ?? 50;
        avgEmergency += feature.emergencyAccessScore ?? 50;
        avgIsolation += feature.isolationScore ?? 0;
        
        if ((feature.hazardScore ?? 0) > maxHazard) {
          maxHazard = feature.hazardScore!;
        }
        
        if (feature.confidence != null && feature.confidence! < minConfidence) {
          minConfidence = feature.confidence!;
          hasConfidence = true;
        }

        if (feature.freshnessTimestamp != null) {
          if (minFreshness == null || feature.freshnessTimestamp!.isBefore(minFreshness)) {
            minFreshness = feature.freshnessTimestamp;
          }
        }
      }
    }
    
    final finalScore = (totalScore / route.length).round();
    
    if (dataPoints > 0) {
      avgLighting /= dataPoints;
      avgActivity /= dataPoints;
      avgEmergency /= dataPoints;
      avgIsolation /= dataPoints;
    }

    final positiveFactors = <SafetyFactor>[];
    final negativeFactors = <SafetyFactor>[];

    // Determine discrete string labels based on exact deterministic thresholds
    if (avgLighting > 75) {
      positiveFactors.add(const SafetyFactor(label: 'Well-lit path', isPositive: true));
    } else if (avgLighting < 30) {
      negativeFactors.add(const SafetyFactor(label: 'Poorly lit areas', isPositive: false));
    }

    if (avgActivity > 70) {
      positiveFactors.add(const SafetyFactor(label: 'High public activity', isPositive: true));
    } else if (avgActivity < 30) {
      negativeFactors.add(const SafetyFactor(label: 'Low foot traffic', isPositive: false));
    }
    
    if (avgEmergency > 70) {
      positiveFactors.add(const SafetyFactor(label: 'Closer to emergency access', isPositive: true));
    }

    if (avgIsolation > 60) {
      negativeFactors.add(const SafetyFactor(label: 'Isolated segments', isPositive: false));
    }
    
    if (maxHazard > 50) {
      negativeFactors.add(const SafetyFactor(label: 'Active hazards', isPositive: false));
    }

    return RouteExplanation(
      overallSafetyScore: finalScore,
      positiveFactors: positiveFactors,
      negativeFactors: negativeFactors,
      confidence: hasConfidence ? minConfidence : null,
      freshness: minFreshness,
    );
  }
}
