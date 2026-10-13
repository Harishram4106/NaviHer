import 'coordinate_utils.dart';

class PointOfInterest {
  final String id;
  final String name;
  final String category;
  final Coordinate location;
  final String? address;
  final bool? isOpen;
  final String? source;
  final String? sourceId;
  final DateTime? freshnessTimestamp;
  final bool isDemo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PointOfInterest({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    this.address,
    this.isOpen,
    this.source,
    this.sourceId,
    this.freshnessTimestamp,
    this.isDemo = false,
    this.createdAt,
    this.updatedAt,
  });

  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    return PointOfInterest(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      location: Coordinate.fromGeoJson(json['geometry'] as Map<String, dynamic>),
      address: json['address'] as String?,
      isOpen: json['is_open'] as bool?,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      freshnessTimestamp: json['freshness_timestamp'] != null ? DateTime.parse(json['freshness_timestamp']) : null,
      isDemo: json['is_demo'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'geometry': location.toGeoJson(),
      'address': address,
      'is_open': isOpen,
      'source': source,
      'source_id': sourceId,
      'freshness_timestamp': freshnessTimestamp?.toIso8601String(),
      'is_demo': isDemo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
