import 'coordinate_utils.dart';

enum ModerationStatus { pending, approved, rejected }

class CommunityReport {
  final String id;
  final String? userId;
  final Coordinate location;
  final String? roadSegmentId;
  final String category;
  final String? description;
  final double? confidence;
  final ModerationStatus moderationStatus;
  final DateTime reportedAt;
  final DateTime? expiresAt;
  final bool isDemo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommunityReport({
    required this.id,
    this.userId,
    required this.location,
    this.roadSegmentId,
    required this.category,
    this.description,
    this.confidence,
    this.moderationStatus = ModerationStatus.pending,
    required this.reportedAt,
    this.expiresAt,
    this.isDemo = false,
    this.createdAt,
    this.updatedAt,
  }) {
    if (confidence != null && (confidence! < 0 || confidence! > 100)) {
      throw ArgumentError('confidence must be between 0 and 100, got $confidence');
    }
  }

  factory CommunityReport.fromJson(Map<String, dynamic> json) {
    return CommunityReport(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      location: Coordinate.fromGeoJson(json['geometry'] as Map<String, dynamic>),
      roadSegmentId: json['road_segment_id'] as String?,
      category: json['category'] as String,
      description: json['description'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      moderationStatus: ModerationStatus.values.firstWhere(
        (e) => e.name == json['moderation_status'],
        orElse: () => throw FormatException('Unknown status: ${json['moderation_status']}'),
      ),
      reportedAt: DateTime.parse(json['reported_at']),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      isDemo: json['is_demo'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'geometry': location.toGeoJson(),
      'road_segment_id': roadSegmentId,
      'category': category,
      'description': description,
      'confidence': confidence,
      'moderation_status': moderationStatus.name,
      'reported_at': reportedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_demo': isDemo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
