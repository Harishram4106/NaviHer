import 'dart:convert';

class RouteHistory {
  final String id;
  final String userId;
  final String name;
  final int durationMinutes;
  final double distanceKm;
  final int safetyScore;
  final String type;
  final List<dynamic>? safetyFactors;
  final List<dynamic>? polyline;
  final DateTime? createdAt;

  const RouteHistory({
    required this.id,
    required this.userId,
    required this.name,
    required this.durationMinutes,
    required this.distanceKm,
    required this.safetyScore,
    required this.type,
    this.safetyFactors,
    this.polyline,
    this.createdAt,
  });

  factory RouteHistory.fromJson(Map<String, dynamic> json) {
    return RouteHistory(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      durationMinutes: json['duration_minutes'] as int,
      distanceKm: (json['distance_km'] as num).toDouble(),
      safetyScore: json['safety_score'] as int,
      type: json['type'] as String,
      safetyFactors: json['safety_factors'] != null
          ? (json['safety_factors'] is String
              ? jsonDecode(json['safety_factors'])
              : json['safety_factors']) as List<dynamic>
          : null,
      polyline: json['polyline'] != null
          ? (json['polyline'] is String
              ? jsonDecode(json['polyline'])
              : json['polyline']) as List<dynamic>
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'duration_minutes': durationMinutes,
      'distance_km': distanceKm,
      'safety_score': safetyScore,
      'type': type,
      'safety_factors': safetyFactors,
      'polyline': polyline,
    };
  }
}
