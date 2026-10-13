import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/map_view_mock.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/models/geospatial/point_of_interest.dart';
import '../../../core/models/route_model.dart';
import 'package:go_router/go_router.dart';
import '../../demo/providers/demo_state_provider.dart';
final activeSessionProvider = FutureProvider.autoDispose<NavigationSession?>((ref) async {
  return ref.watch(navigationRepositoryProvider).getActiveSession();
});

final poisProvider = FutureProvider.autoDispose<List<PointOfInterest>>((ref) async {
  return ref.watch(pointOfInterestRepositoryProvider).getNearbyPointsOfInterest(37.7749, -122.4194, 1000);
});

class SafetyCorridorScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const SafetyCorridorScreen({super.key, required this.onBack});

  @override
  ConsumerState<SafetyCorridorScreen> createState() => _SafetyCorridorScreenState();
}

class _SafetyCorridorScreenState extends ConsumerState<SafetyCorridorScreen> {
  int _activeFilter = 0; // 0=Safe Corridor, 1=Risk Areas, 2=POIs

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen dark map
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _showPoiBottomSheet(context),
              child: MapViewMock(isNavigation: true),
            ),
          ),

          // ── TOP OVERLAY: header + filter tabs ─────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: topPad + 12),

                  // App bar row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onBack,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.90),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.90),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safety Corridor',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          'Safer areas around you',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Filter tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip(0, Icons.shield_rounded, 'Safe Corridor'),
                        const SizedBox(width: 8),
                        _buildFilterChip(1, Icons.warning_amber_rounded, 'Risk Areas'),
                        const SizedBox(width: 8),
                        _buildFilterChip(2, Icons.location_on_rounded, 'POIs'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Map legend (top-right of map area) ────────────────────
          Positioned(
            top: topPad + 180,
            right: 16,
            child: GlassContainer.neutral(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendItem(AppColors.riskLow, 'Low Risk'),
                  const SizedBox(height: 5),
                  _buildLegendItem(AppColors.riskModerate, 'Moderate Risk'),
                  const SizedBox(height: 5),
                  _buildLegendItem(AppColors.riskHigh, 'High Risk'),
                ],
              ),
            ),
          ),

          // ── Location target FAB ───────────────────────────────────
          Positioned(
            bottom: botPad + 280,
            right: 16,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.90),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 22),
            ),
          ),

          // ── BOTTOM: Safe Places List ────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.background, AppColors.background.withValues(alpha: 0.95), Colors.transparent],
                  stops: const [0.0, 0.85, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 12),
                    child: Text(
                      'Nearby Safe Places',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, botPad + 16),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSafePlaceCard('Anna Nagar Police Station', '0.8 km', 'Open 24/7', Icons.local_police_rounded, AppColors.poiPolice),
                        const SizedBox(width: 12),
                        _buildSafePlaceCard('City Hospital', '1.2 km', 'Emergency services', Icons.local_hospital_rounded, AppColors.poiHospital),
                        const SizedBox(width: 12),
                        _buildSafePlaceCard('Apollo Pharmacy', '1.5 km', 'Well lit, Open 24/7', Icons.local_pharmacy_rounded, AppColors.poiPharmacy),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int idx, IconData icon, String label) {
    final isActive = _activeFilter == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPink : AppColors.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: isActive ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? Colors.white : AppColors.textSecondary, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSafePlaceCard(String name, String distance, String desc, IconData icon, Color color) {
    return SizedBox(
      width: 240,
      child: GlassContainer.custom(
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderColor: color,
        borderOpacity: 0.5,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const Spacer(),
          Text('$distance • $desc', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              final session = ref.read(activeSessionProvider).valueOrNull;
              if (session != null) {
                final newRoute = RouteModel(
                  id: 'safe_place_1',
                  name: name,
                  durationMinutes: 5,
                  distanceKm: 0.8,
                  safetyScore: 95,
                  safetyFactors: session.activeRoute.safetyFactors,
                  type: RoutePreference.naviherSafe,
                  polyline: session.activeRoute.polyline,
                );
                ref.read(demoStateProvider.notifier).setActiveRoute(newRoute);
              }
              context.push('/navigation');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Center(
                child: Text('Navigate Here', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  void _showPoiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer.neutral(
        padding: const EdgeInsets.all(24),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.poiPolice.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_police_rounded, color: AppColors.poiPolice, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Anna Nagar Police Station', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('0.8 km away • Open 24/7', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPoiAction(Icons.call_rounded, 'Call', AppColors.primaryPink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPoiAction(Icons.directions_rounded, 'Navigate', AppColors.secondaryPurple, onTap: () {
                    final session = ref.read(activeSessionProvider).valueOrNull;
                    if (session != null) {
                      final newRoute = RouteModel(
                        id: 'safe_place_bottom_sheet',
                        name: 'Anna Nagar Police Station',
                        durationMinutes: 5,
                        distanceKm: 0.8,
                        safetyScore: 95,
                        safetyFactors: session.activeRoute.safetyFactors,
                        type: RoutePreference.naviherSafe,
                        polyline: session.activeRoute.polyline,
                      );
                      ref.read(demoStateProvider.notifier).setActiveRoute(newRoute);
                    }
                    context.push('/navigation');
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPoiAction(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
