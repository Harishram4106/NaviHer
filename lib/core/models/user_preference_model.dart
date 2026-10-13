class UserPreference {
  final String id;
  final String userId;
  final bool shareLocationAutomatically;
  final String preferredTransportMode;
  final double alertRadiusKm;

  const UserPreference({
    required this.id,
    required this.userId,
    this.shareLocationAutomatically = false,
    this.preferredTransportMode = 'walking',
    this.alertRadiusKm = 2.0,
  });

  factory UserPreference.fromJson(Map<String, dynamic> json) {
    return UserPreference(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      shareLocationAutomatically: json['share_location_automatically'] as bool? ?? false,
      preferredTransportMode: json['preferred_transport_mode'] as String? ?? 'walking',
      alertRadiusKm: (json['alert_radius_km'] as num?)?.toDouble() ?? 2.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'share_location_automatically': shareLocationAutomatically,
      'preferred_transport_mode': preferredTransportMode,
      'alert_radius_km': alertRadiusKm,
    };
  }
}
