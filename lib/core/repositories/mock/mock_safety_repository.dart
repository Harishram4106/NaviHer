import '../../models/safety_models.dart';
import '../../models/report_model.dart';
import '../safety_repository.dart';

/// MOCK — NaviHer Safety Repository
/// Uses hardcoded demo data. Replace with Supabase in Phase 2.
class MockSafetyRepository implements SafetyRepository {
  @override
  Future<SafetyStatusModel> getCurrentSafetyStatus() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const SafetyStatusModel(
      label: 'Your Safety Status Looks Good',
      description: 'Low risk in your current area',
      score: 87,
      level: SafetyLevel.safe,
    );
  }

  @override
  Future<List<PointOfInterest>> getNearbyAssistance({
    PoiCategory? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = _mockPois;
    if (category == null || category == PoiCategory.all) return all;
    return all.where((p) => p.category == category).toList();
  }

  @override
  Future<void> submitReport(SafetyReport report) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // In Phase 2: post to Supabase
  }
}

// ─── Mock Data ───────────────────────────────────────────────────────────────

const _mockPois = [
  PointOfInterest(
    id: 'poi-001',
    name: 'Central Police Station',
    category: PoiCategory.police,
    distanceKm: 0.8,
    availability: 'Open 24/7',
    isOpen: true,
    lat: 37.7760,
    lng: -122.4170,
  ),
  PointOfInterest(
    id: 'poi-002',
    name: 'City Hospital',
    category: PoiCategory.hospital,
    distanceKm: 1.2,
    availability: '5 min away',
    isOpen: true,
    lat: 37.7745,
    lng: -122.4190,
  ),
  PointOfInterest(
    id: 'poi-003',
    name: 'Wellness Pharmacy',
    category: PoiCategory.pharmacy,
    distanceKm: 0.6,
    availability: 'Open until 10 PM',
    isOpen: true,
    lat: 37.7752,
    lng: -122.4182,
  ),
  PointOfInterest(
    id: 'poi-004',
    name: 'Community Center',
    category: PoiCategory.publicPlace,
    distanceKm: 0.4,
    availability: 'Open until 9 PM',
    isOpen: true,
    lat: 37.7748,
    lng: -122.4178,
  ),
];
