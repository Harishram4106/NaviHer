import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';

class NavigationSearchScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onFindRoutes;

  const NavigationSearchScreen({
    super.key,
    required this.onBack,
    required this.onFindRoutes,
  });

  @override
  ConsumerState<NavigationSearchScreen> createState() =>
      _NavigationSearchScreenState();
}

class _NavigationSearchScreenState extends ConsumerState<NavigationSearchScreen> {
  int _travelContext = 0; // 0=Alone, 1=With Friends, 2=At Night
  int _routePreference = 0; // 0=NaviHer Safe, 1=Fastest
  bool _destinationSelected = false;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              // Extra bottom padding so Route Preference cards scroll
              // fully above the fixed Find Routes CTA (≈ 56px button +
              // 16px top pad + bottom inset + 20px margin).
              padding: EdgeInsets.only(
                bottom: 92 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPad + 16),

                  // ── App Bar ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onBack,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
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
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Title ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Your Journey',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find safer routes, together',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── From / To fields ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          // From
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Pink A circle
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryPink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('From', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                                      Text('Anna Nagar', style: GoogleFonts.inter(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.my_location_rounded, color: AppColors.primaryPink, size: 20),
                              ],
                            ),
                          ),

                          // Dashed separator + dots
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Column(
                              children: List.generate(3, (i) => Container(
                                width: 3,
                                height: 5,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.border,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )),
                            ),
                          ),

                          // To
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _destinationSelected = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Purple B circle
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondaryPurple,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('To', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                                        Text(_destinationSelected ? 'VR Mall' : 'Where are you going?', style: GoogleFonts.inter(fontSize: 15, color: _destinationSelected ? Colors.white : AppColors.textMuted, fontWeight: _destinationSelected ? FontWeight.w600 : FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.location_on_outlined, color: _destinationSelected ? AppColors.secondaryPurple : AppColors.textMuted, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Travel Context ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Travel Context',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Help us understand your journey',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: _buildContextCard(0, Icons.person_rounded, 'Alone', 'Just me')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildContextCard(1, Icons.group_rounded, 'With Friends', 'Group travel')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildContextCard(2, Icons.nightlight_rounded, 'At Night', 'Evening / Late')),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Route Preference ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Route Preference',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose what matters most to you',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildRouteCard(
                                0,
                                Icons.shield_rounded,
                                'NaviHer Safe Route',
                                'Prioritizes safety, well-lit areas and trusted routes',
                                AppColors.primaryPink,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: _buildRouteCard(
                                1,
                                Icons.flash_on_rounded,
                                'Fastest Route',
                                'Shortest time and distance',
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Find Routes button (always visible at bottom) ──────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // Gradient to blend CTA into background smoothly
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.0),
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background,
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 32, 20, MediaQuery.of(context).padding.bottom + 20),
              child: GestureDetector(
                onTap: widget.onFindRoutes,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPink.withValues(alpha: 0.40),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Find Routes',
                        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextCard(int idx, IconData icon, String title, String subtitle) {
    final isSelected = _travelContext == idx;
    return GestureDetector(
      onTap: () => setState(() => _travelContext = idx),
      child: GlassContainer.custom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        backgroundColor: isSelected ? AppColors.primaryPink.withValues(alpha: 0.12) : AppColors.surface,
        borderColor: isSelected ? AppColors.primaryPink : AppColors.border,
        borderOpacity: isSelected ? 1.0 : 0.12,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(int idx, IconData icon, String title, String subtitle, Color accentColor) {
    final isSelected = _routePreference == idx;
    return GestureDetector(
      onTap: () => setState(() => _routePreference = idx),
      child: GlassContainer.custom(
        padding: const EdgeInsets.all(14),
        backgroundColor: isSelected ? AppColors.primaryPink.withValues(alpha: 0.10) : AppColors.surface,
        borderColor: isSelected ? AppColors.primaryPink : AppColors.border,
        borderOpacity: isSelected ? 1.0 : 0.12,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: isSelected ? AppColors.primaryPink : AppColors.textMuted, size: 20),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
