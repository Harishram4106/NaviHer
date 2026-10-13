import '../../../core/models/geospatial/community_report.dart';
import '../../../core/models/geospatial/hazard.dart';

class SafetySignalAggregator {
  /// Aggregates hazards and community reports into a hazard score (0-100) and risk signal score (0-100).
  /// Returns a tuple of (hazardScore, riskSignalScore).
  (double, double) aggregateSignals({
    required List<Hazard> hazards,
    required List<CommunityReport> reports,
  }) {
    double hazardScore = 0.0;
    double riskSignalScore = 0.0;

    // Process hazards (max 100)
    for (final hazard in hazards) {
      if (hazard.status == HazardStatus.active) {
        // Use severity, fallback to 50 if null
        double severity = hazard.severity ?? 50.0;
        
        // Decay based on confidence if available
        double confidenceMultiplier = (hazard.confidence ?? 100.0) / 100.0;
        
        hazardScore += severity * confidenceMultiplier;
      }
    }

    // Process community reports (max 100)
    // 1 report is a candidate signal (e.g. 15 points).
    // Multiple reports corroborate (e.g. 2 reports = 30 points).
    for (final report in reports) {
      double reportValue = 15.0; // Base value for a single anonymous report
      
      // Decay based on confidence if available
      double confidenceMultiplier = (report.confidence ?? 100.0) / 100.0;
      
      // Decay based on age if reportedAt is available
      final ageHours = DateTime.now().difference(report.reportedAt).inHours;
      if (ageHours > 24) {
        reportValue *= 0.5; // Older than 24h is worth less
      }
      
      riskSignalScore += reportValue * confidenceMultiplier;
    }

    return (
      hazardScore.clamp(0.0, 100.0),
      riskSignalScore.clamp(0.0, 100.0)
    );
  }
}
