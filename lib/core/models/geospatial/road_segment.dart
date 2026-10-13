import 'coordinate_utils.dart';

class RoadSegment {
  final String id;
  final String? externalId;
  final String? name;
  final List<Coordinate> geometry;
  final double? lengthMeters;
  final int? estimatedTravelTimeSeconds;
  final String? source;
  final String? sourceId;
  final bool isDemo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoadSegment({
    required this.id,
    this.externalId,
    this.name,
    required this.geometry,
    this.lengthMeters,
    this.estimatedTravelTimeSeconds,
    this.source,
    this.sourceId,
    this.isDemo = false,
    this.createdAt,
    this.updatedAt,
  }) {
    if (lengthMeters != null && lengthMeters! < 0) {
      throw ArgumentError('lengthMeters cannot be negative');
    }
    if (estimatedTravelTimeSeconds != null && estimatedTravelTimeSeconds! < 0) {
      throw ArgumentError('estimatedTravelTimeSeconds cannot be negative');
    }
  }

  factory RoadSegment.fromJson(Map<String, dynamic> json) {
    return RoadSegment(
      id: json['id'] as String,
      externalId: json['external_id'] as String?,
      name: json['name'] as String?,
      // We expect the SQL function to return geometry as a GeoJSON object in a jsonb field
      geometry: CoordinateUtils.parseLineString(json['geometry'] as Map<String, dynamic>),
      lengthMeters: (json['length_meters'] as num?)?.toDouble(),
      estimatedTravelTimeSeconds: json['estimated_travel_time_seconds'] as int?,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      isDemo: json['is_demo'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'external_id': externalId,
      'name': name,
      'geometry': CoordinateUtils.toLineString(geometry),
      'length_meters': lengthMeters,
      'estimated_travel_time_seconds': estimatedTravelTimeSeconds,
      'source': source,
      'source_id': sourceId,
      'is_demo': isDemo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
