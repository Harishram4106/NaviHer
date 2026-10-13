import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/map_view_mock.dart';
import '../../../core/models/route_model.dart';
import '../../../core/models/route_history_model.dart';
import '../../route_history/providers/route_history_provider.dart';
import '../../demo/providers/demo_state_provider.dart';
import 'package:go_router/go_router.dart';

class NavigationProgressScreen extends ConsumerStatefulWidget {
  final RouteModel? route;
  final VoidCallback onEndTrip;

  const NavigationProgressScreen({
    super.key,
    this.route,
    required this.onEndTrip,
  });

  @override
  ConsumerState<NavigationProgressScreen> createState() =>
      _NavigationProgressScreenState();
}

class _NavigationProgressScreenState extends ConsumerState<NavigationProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    final demoState = ref.watch(demoStateProvider);
    final navState = demoState.navigationState;

    String instruction = 'Continue straight on Main Road';
    String distance = '600 m';
    IconData dirIcon = Icons.arrow_upward_rounded;
    Color iconColor = Colors.white;

    if (navState == DemoNavigationState.navigating) {
      instruction = 'Continue straight on Main Road';
      distance = '250 m';
      dirIcon = Icons.arrow_upward_rounded;
    } else if (navState == DemoNavigationState.hazardDetected || navState == DemoNavigationState.recalculating || navState == DemoNavigationState.alternativeProposed) {
      instruction = 'Hazard Ahead: Road construction';
      distance = '150 m';
      dirIcon = Icons.warning_amber_rounded;
      iconColor = AppColors.warning;
    } else if (navState == DemoNavigationState.alternativeAccepted) {
      instruction = 'NEW ROUTE: Turn left toward Safer Street';
      distance = '100 m';
      dirIcon = Icons.turn_left_rounded;
      iconColor = AppColors.success;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen dark 3D map
          Positioned.fill(
            child: MapViewMock(isNavigation: true),
          ),

          // ── TOP: Turn-by-turn banner ─────────────────────────────
          Positioned(
            top: topPad + 12,
            left: 16,
            right: 72, // leave space for compass FAB
            child: GlassContainer.neutral(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              borderRadius: BorderRadius.circular(AppRadius.large),
              child: Row(
                children: [
                  Icon(dirIcon, color: iconColor, size: 42),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          distance,
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                        ),
                        Text(
                          instruction,
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Voice guidance toggled.', style: TextStyle(color: Colors.white)),
                          backgroundColor: AppColors.surfaceElevated,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: const Icon(Icons.volume_up_rounded, color: Colors.white70, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── TOP-LEFT: Safety Intelligence Panel ───────────────────
          Positioned(
            left: 16,
            top: topPad + 110,
            child: GlassContainer.neutral(
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NaviHer Safety Intelligence', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryPink)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 12),
                      const SizedBox(width: 6),
                      Text('5 positive signals', style: GoogleFonts.inter(fontSize: 11, color: Colors.white)),
                    ]
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 12),
                      const SizedBox(width: 6),
                      Text('2 risk signals', style: GoogleFonts.inter(fontSize: 11, color: Colors.white)),
                    ]
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, color: AppColors.info, size: 12),
                      const SizedBox(width: 6),
                      Text('1 community report', style: GoogleFonts.inter(fontSize: 11, color: Colors.white)),
                    ]
                  ),
                  const SizedBox(height: 8),
                  Text('Confidence: High', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),

          // ── TOP-RIGHT: Compass FAB + Action FABs ─────────────────
          Positioned(
            top: topPad + 12,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pink compass/navigation arrow
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Map re-centered to your location.', style: TextStyle(color: Colors.white)),
                        backgroundColor: AppColors.surfaceElevated,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPink.withValues(alpha: 0.50),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(height: 12),
                // Safety FAB
                _buildActionFab(Icons.shield_rounded, 'Safety', AppColors.primaryPink, () => context.push('/safety-corridor')),
                const SizedBox(height: 10),
                // Emergency FAB
                _buildActionFab(Icons.group_rounded, 'Emergency', AppColors.secondaryPurple, () => context.push('/emergency')),
                const SizedBox(height: 10),
                // Report FAB
                _buildActionFab(Icons.warning_amber_rounded, 'Report', const Color(0xFF374162), () => context.push('/report')),
                const SizedBox(height: 10),
                // Advance Demo FAB
                _buildActionFab(Icons.fast_forward_rounded, 'Simulate', Colors.green, _advanceDemoState),
              ],
            ),
          ),

          // ── BOTTOM: trip info bar ─────────────────────────────────
          Positioned(
            bottom: botPad + 12,
            left: 16,
            right: 16,
            child: GlassContainer.neutral(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              borderRadius: BorderRadius.circular(AppRadius.large),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '12 min',
                        style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                      ),
                      Text(
                        '3.1 km  ·  Arrive 9:53 PM',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                  // End Trip button
                  GestureDetector(
                    onTap: () {
                      if (widget.route != null) {
                        final historyEntry = RouteHistory(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: 'dummy_user_id',
                          name: widget.route!.name,
                          type: widget.route!.type == RoutePreference.naviherSafe ? 'NaviHer Safe' : 'Fastest',
                          durationMinutes: widget.route!.durationMinutes,
                          distanceKm: widget.route!.distanceKm,
                          safetyScore: widget.route!.safetyScore,
                          createdAt: DateTime.now(),
                        );
                        ref.read(routeHistoryProvider.notifier).addHistory(historyEntry);
                      }
                      widget.onEndTrip();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withValues(alpha: 0.40),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text('End Trip', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── CENTER: Cinematic Rerouting Overlay ─────────────────────
          if (navState == DemoNavigationState.hazardDetected || 
              navState == DemoNavigationState.recalculating || 
              navState == DemoNavigationState.alternativeProposed)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.75),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GlassContainer.custom(
                    padding: const EdgeInsets.all(24),
                    backgroundColor: AppColors.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    borderColor: AppColors.warning,
                    borderOpacity: 1.0,
                    showShadow: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 48),
                        const SizedBox(height: 16),
                        Text('Safety Intelligence Activated', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 12),
                        
                        if (navState == DemoNavigationState.hazardDetected || navState == DemoNavigationState.recalculating) ...[
                          const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: AppColors.warning, strokeWidth: 2)),
                          const SizedBox(height: 16),
                          Text('Re-evaluating route safety...', style: GoogleFonts.inter(fontSize: 14, color: AppColors.warning)),
                        ],
                        
                        if (navState == DemoNavigationState.alternativeProposed) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('CURRENT', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text('Safety 68', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.warning)),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white54),
                                Column(
                                  children: [
                                    Text('ALTERNATIVE', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text('Safety 87', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.success)),
                                    Text('+4 min', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryPink)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                ref.read(demoStateProvider.notifier).updateNavState(DemoNavigationState.alternativeAccepted);
                              },
                              child: Text('Take Safer Route', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFab(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.transparent, // Hack: make it transparent so it doesn't show, but keeps the layout
              shadows: [],
            ),
          ),
        ],
      ),
    );
  }

  void _advanceDemoState() {
    final demoState = ref.read(demoStateProvider);
    if (demoState.navigationState == DemoNavigationState.navigating) {
      ref.read(demoStateProvider.notifier).updateNavState(DemoNavigationState.hazardDetected);
      
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        ref.read(demoStateProvider.notifier).updateNavState(DemoNavigationState.recalculating);
        
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          ref.read(demoStateProvider.notifier).updateNavState(DemoNavigationState.alternativeProposed);
        });
      });
    }
  }
}
