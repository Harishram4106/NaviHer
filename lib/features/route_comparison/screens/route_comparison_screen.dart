import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/map_view_mock.dart';
import '../../../core/models/route_model.dart';
import '../../../core/providers/repository_providers.dart';

final mockRoutesProvider = FutureProvider.autoDispose<List<RouteModel>>((ref) async {
  final repo = ref.watch(navigationRepositoryProvider);
  return repo.getRoutes(from: 'Anna Nagar', to: 'VR Mall', mode: RouteTravelMode.alone);
});

class RouteComparisonScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<RouteModel> onSelectRoute;

  const RouteComparisonScreen({
    super.key,
    required this.onBack,
    required this.onSelectRoute,
  });

  @override
  ConsumerState<RouteComparisonScreen> createState() => _RouteComparisonScreenState();
}

class _RouteComparisonScreenState extends ConsumerState<RouteComparisonScreen> {
  int _selectedTab = 0; // 0 = NaviHer Safe, 1 = Fastest

  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(mockRoutesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: routesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
          data: (routes) {
            final safeRoute = routes.firstWhere((r) => r.type == RoutePreference.naviherSafe, orElse: () => routes.first);
            final fastRoute = routes.firstWhere((r) => r.type == RoutePreference.fastest, orElse: () => routes.last);
            
            return Column(
              children: [
                // ── Top app bar and tab selector ─────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Route Comparison',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(4)),
                        child: Text('Demo Simulation', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                  Text(
                    'Choose the route that feels right for you',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Route tab selector
                  Row(
                    children: [
                      Expanded(child: _buildTabPill(0, Icons.shield_rounded, 'NaviHer Safe', 'Safer, recommended')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildTabPill(1, Icons.flash_on_rounded, 'Fastest Route', 'Quickest arrival')),
                    ],
                  ),
                ],
              ),
            ),

            // ── Map container ──────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: MapViewMock(
                          isComparison: true,
                          activeComparisonTab: _selectedTab,
                        ),
                      ),
                      // Layers FAB (top-right of map)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Map layers are disabled in this prototype demo.', style: TextStyle(color: Colors.white)),
                                backgroundColor: AppColors.surfaceElevated,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.layers_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Route details cards ─────────────────────────────────
            // ── Route details bottom sheet ──────────────────────────────
            GlassContainer.neutral(
              padding: const EdgeInsets.all(20),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedTab == 0 ? 'NaviHer Safe' : 'Fastest Route', 
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                      if (_selectedTab == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.shield_rounded, color: AppColors.primaryPink, size: 14),
                              const SizedBox(width: 4),
                              Text('Recommended', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryPink)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Trade-off card
                  GlassContainer.custom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    borderColor: _selectedTab == 0 ? AppColors.primaryPink : AppColors.border,
                    borderOpacity: _selectedTab == 0 ? 1.0 : 0.12,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatValue('Time', _selectedTab == 0 ? '${safeRoute.durationMinutes} min' : '${fastRoute.durationMinutes} min', Icons.schedule),
                            _buildStatValue('Distance', _selectedTab == 0 ? '${safeRoute.distanceKm} km' : '${fastRoute.distanceKm} km', Icons.route),
                            _buildStatValue('Safety', _selectedTab == 0 ? '${safeRoute.safetyScore}' : '${fastRoute.safetyScore}', Icons.health_and_safety),
                            _buildStatValue('Risk Areas', _selectedTab == 0 ? '1' : '3', Icons.warning_amber_rounded),
                          ],
                        ),
                        if (_selectedTab == 0) ...[
                          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.border)),
                          GestureDetector(
                            onTap: _showWhySaferSheet,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Why is this safer?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryPink)),
                                const SizedBox(width: 4),
                                const Icon(Icons.help_outline, color: AppColors.primaryPink, size: 16),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Choose CTA
                  GestureDetector(
                    onTap: () {
                      final routeToPass = _selectedTab == 0 ? safeRoute : fastRoute;
                      widget.onSelectRoute(routeToPass);
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? AppColors.primaryPink : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: _selectedTab == 0 ? [
                          BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.40), blurRadius: 20, offset: const Offset(0, 6)),
                        ] : null,
                      ),
                      child: Center(
                        child: Text(
                          _selectedTab == 0 ? 'Choose NaviHer Safe' : 'Choose Fastest Route', 
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabPill(int idx, IconData icon, String title, String subtitle) {
    final isSelected = _selectedTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = idx),
      child: GlassContainer.custom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        backgroundColor: isSelected ? AppColors.primaryPink.withValues(alpha: 0.15) : AppColors.surface.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderColor: isSelected ? AppColors.primaryPink : AppColors.border,
        borderOpacity: isSelected ? 1.0 : 0.12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryPink : AppColors.textSecondary, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatValue(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }

  void _showWhySaferSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassContainer.neutral(
        padding: const EdgeInsets.all(24.0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WHY THIS ROUTE?', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryPink, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Safety Score', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                const Spacer(),
                GlassContainer.green(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  borderRadius: BorderRadius.circular(12),
                  child: Text('89 / 100', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.success)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildWhyItem('Better lighting', Icons.check_rounded),
            _buildWhyItem('Higher public activity', Icons.check_rounded),
            _buildWhyItem('Nearby emergency facilities', Icons.check_rounded),
            _buildWhyItem('Lower isolation', Icons.check_rounded),
            const SizedBox(height: 24),
            Text('Trade-off', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('+4 min', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryPink)),
                const SizedBox(width: 16),
                Text('+0.3 km', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryPink)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildWhyItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
