import 'coordinate_utils.dart';

enum HazardStatus { active, resolved, expired }

class Hazard {
  final String id;
  final Coordinate location;
  final String? roadSegmentId;
  final String category;
  final double? severity;
  final double? confidence;
  final String? description;
  final String? source;
  final String? sourceId;
  final DateTime reportedAt;
  final DateTime? expiresAt;
  final HazardStatus status;
  final bool isDemo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Hazard({
    required this.id,
    required this.location,
    this.roadSegmentId,
    required this.category,
    this.severity,
    this.confidence,
    this.description,
    this.source,
    this.sourceId,
    required this.reportedAt,
    this.expiresAt,
    required this.status,
    this.isDemo = false,
    this.createdAt,
    this.updatedAt,
  }) {
    if (severity != null && (severity! < 0 || severity! > 100)) {
      throw ArgumentError('severity must be between 0 and 100, got $severity');
    }
    if (confidence != null && (confidence! < 0 || confidence! > 100)) {
      throw ArgumentError('confidence must be between 0 and 100, got $confidence');
    }
  }

  factory Hazard.fromJson(Map<String, dynamic> json) {
    return Hazard(
      id: json['id'] as String,
      location: Coordinate.fromGeoJson(json['geometry'] as Map<String, dynamic>),
      roadSegmentId: json['road_segment_id'] as String?,
      category: json['category'] as String,
      severity: (json['severity'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      description: json['description'] as String?,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      reportedAt: DateTime.parse(json['reported_at']),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      status: HazardStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => throw FormatException('Unknown status: ${json['status']}'),
      ),
      isDemo: json['is_demo'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'geometry': location.toGeoJson(),
      'road_segment_id': roadSegmentId,
      'category': category,
      'severity': severity,
      'confidence': confidence,
      'description': description,
      'source': source,
      'source_id': sourceId,
      'reported_at': reportedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status.name,
      'is_demo': isDemo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
