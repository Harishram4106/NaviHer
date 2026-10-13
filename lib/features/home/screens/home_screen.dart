import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/naviher_bottom_nav.dart';
import '../../../shared/widgets/glass_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;
  final VoidCallback onSearchTap;
  final VoidCallback onReportTap;
  final VoidCallback onEmergencyTap;
  final VoidCallback onSafetyTap;
  final VoidCallback onShareLocationTap;
  final VoidCallback onEmergencyContactsTap;

  const HomeScreen({
    super.key,
    required this.navIndex,
    required this.onNavTap,
    required this.onSearchTap,
    required this.onReportTap,
    required this.onEmergencyTap,
    required this.onSafetyTap,
    required this.onShareLocationTap,
    required this.onEmergencyContactsTap,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPad + 16),

                  // ── Top Bar ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Navi',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Her',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryPink, width: 2),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/naviher_logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const CircleAvatar(
                                backgroundColor: AppColors.secondaryPurple,
                                child: Text('P', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Bell
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Safer Together',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Greeting ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening,',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Priya ',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const Text('👋', style: TextStyle(fontSize: 26)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Search bar ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: widget.onSearchTap,
                      child: GlassContainer.neutral(
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: 54,
                          child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Where do you want to go?',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.mic_rounded, color: AppColors.textSecondary, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                  const SizedBox(height: 20),

                  // ── Category quick-links ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategory(Icons.home_rounded, 'Home', const Color(0xFF7B2D52)),
                        _buildCategory(Icons.work_rounded, 'Work', AppColors.surfaceElevated),
                        _buildCategory(Icons.school_rounded, 'College', AppColors.surfaceElevated),
                        _buildCategory(Icons.restaurant_rounded, 'Food', AppColors.surfaceElevated),
                        _buildCategory(Icons.more_horiz_rounded, 'More', AppColors.surfaceElevated),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Safety status card ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.verified_user_rounded, color: AppColors.success, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You're in a Safe Area",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Low risk in your current location',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Safety Score: 92/100',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onSafetyTap,
                            child: Text(
                              'View map →',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick Actions ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quick Actions',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'See all',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _buildQuickAction(Icons.shield_rounded, "I'm Feeling\nUnsafe", AppColors.primaryPink, widget.onEmergencyTap)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQuickAction(Icons.group_rounded, 'Share\nMy Location', AppColors.secondaryPurple, widget.onShareLocationTap)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQuickAction(Icons.campaign_rounded, 'Report\nan Incident', AppColors.primaryPink, widget.onReportTap)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQuickAction(Icons.phone_rounded, 'Emergency\nContacts', AppColors.primaryPink, widget.onEmergencyContactsTap)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Nearby You ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby You',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'See all',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildNearbyCard(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom nav
          NaviHerBottomNav(
            currentIndex: widget.navIndex,
            onTap: widget.onNavTap,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(IconData icon, String label, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer.neutral(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyCard() {
    return GlassContainer.neutral(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Road photo / thumbnail (dark illustration placeholder)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2040),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: const Icon(Icons.streetview_rounded, color: Color(0xFF4B6080), size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anna Nagar Main Road',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Well Lit · Active Area',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '0.8 km away',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
