// NaviHer AI — Incident Report Model

enum ReportCategory {
  brokenStreetlight,
  suspiciousActivity,
  unsafeArea,
  harassment,
  roadHazard,
  other,
}

extension ReportCategoryExtension on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.brokenStreetlight:
        return 'Broken Streetlight';
      case ReportCategory.suspiciousActivity:
        return 'Suspicious Activity';
      case ReportCategory.unsafeArea:
        return 'Unsafe Area';
      case ReportCategory.harassment:
        return 'Harassment';
      case ReportCategory.roadHazard:
        return 'Road Hazard';
      case ReportCategory.other:
        return 'Other';
    }
  }
}

class SafetyReport {
  final String id;
  final ReportCategory category;
  final String? description;
  final String? photoPath;
  final DateTime reportedAt;
  final double lat;
  final double lng;
  final bool isSubmitted;

  const SafetyReport({
    required this.id,
    required this.category,
    this.description,
    this.photoPath,
    required this.reportedAt,
    required this.lat,
    required this.lng,
    this.isSubmitted = false,
  });
}
