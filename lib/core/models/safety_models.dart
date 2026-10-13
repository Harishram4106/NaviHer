// NaviHer AI — Safety & POI Models

enum PoiCategory { all, police, hospital, pharmacy, publicPlace }

class PointOfInterest {
  final String id;
  final String name;
  final PoiCategory category;
  final double distanceKm;
  final String availability; // e.g., "Open 24/7", "Open until 10 PM"
  final bool isOpen;
  final double lat;
  final double lng;

  const PointOfInterest({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.availability,
    required this.isOpen,
    required this.lat,
    required this.lng,
  });
}

class SafetyStatusModel {
  final String label;
  final String description;
  final int score; // 0–100
  final SafetyLevel level;

  const SafetyStatusModel({
    required this.label,
    required this.description,
    required this.score,
    required this.level,
  });
}

enum SafetyLevel { safe, moderate, risky, danger }

class TrustedContact {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final bool isNotified;

  const TrustedContact({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    this.isNotified = false,
  });
}
