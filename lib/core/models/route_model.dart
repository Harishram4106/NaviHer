// NaviHer AI — Route Models
// These typed models represent route data.
// Supabase integration will replace mock repositories in a later phase.

enum RouteTravelMode { alone, withFriends, atNight }

enum RoutePreference { naviherSafe, fastest }

class SafetyFactor {
  final String label;
  final bool isPositive;

  const SafetyFactor({required this.label, required this.isPositive});
}

class RouteModel {
  final String id;
  final String name;
  final int durationMinutes;
  final double distanceKm;
  final int safetyScore; // 0–100
  final List<SafetyFactor> safetyFactors;
  final RoutePreference type;
  final List<LatLng> polyline;

  const RouteModel({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.distanceKm,
    required this.safetyScore,
    required this.safetyFactors,
    required this.type,
    required this.polyline,
  });
}

class LatLng {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);
}

class NavigationInstruction {
  final String direction; // e.g., "Turn right"
  final String streetName;
  final int distanceMeters;
  final String iconAsset; // e.g., arrow direction type

  const NavigationInstruction({
    required this.direction,
    required this.streetName,
    required this.distanceMeters,
    required this.iconAsset,
  });
}

class NavigationSession {
  final RouteModel activeRoute;
  final NavigationInstruction currentInstruction;
  final int etaMinutes;
  final double remainingKm;
  final bool isActive;

  const NavigationSession({
    required this.activeRoute,
    required this.currentInstruction,
    required this.etaMinutes,
    required this.remainingKm,
    required this.isActive,
  });
}
