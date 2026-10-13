import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/naviher_bottom_nav.dart';
import '../widgets/trusted_contacts_sheet.dart';
import '../widgets/safety_preferences_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const ProfileScreen({
    super.key,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Navi',
                                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Her',
                                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryPink),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Safer Together',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Profile card ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar with photo icon overlay
                          Stack(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF9B7CA0), Color(0xFF6B5580)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Text('PS', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPink,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.surface, width: 2),
                                  ),
                                  child: const Icon(Icons.photo_camera_rounded, color: Colors.white, size: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Priya Sharma',
                                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'priya.sharma@example.com',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Stay Safe', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                      const SizedBox(width: 4),
                                      const Text('✨', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Stats row ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: EdgeInsets.zero,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(child: _buildStat(Icons.shield_rounded, '12', 'Reports Made', AppColors.secondaryPurple)),
                            _buildVertDivider(),
                            Expanded(child: _buildStat(Icons.group_rounded, '8', 'People Helped', AppColors.secondaryPurple)),
                            _buildVertDivider(),
                            Expanded(child: _buildStat(Icons.star_rounded, '28', 'Days Active', AppColors.primaryPink)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Settings ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildSettingsRow(Icons.history_rounded, 'Route History', 'View past trips and safety stats', AppColors.secondaryPurple, onTap: () => context.push('/route-history')),
                          _buildDivider(),
                          _buildSettingsRow(Icons.person_rounded, 'Personal Information', 'Manage your profile', AppColors.secondaryPurple, onTap: () => _showMockNotImplemented(context, 'Personal Information')),
                          _buildDivider(),
                          _buildSettingsRow(Icons.group_add_rounded, 'Trusted Contacts', 'Add and manage emergency contacts', AppColors.secondaryPurple, onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const TrustedContactsSheet(),
                            );
                          }),
                          _buildDivider(),
                          _buildSettingsRow(Icons.security_rounded, 'Safety Preferences', 'Customize your safety settings', AppColors.secondaryPurple, onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const SafetyPreferencesSheet(),
                            );
                          }),
                          _buildDivider(),
                          _buildSettingsRow(Icons.settings_rounded, 'App Settings', 'Notifications, privacy, appearance', AppColors.textMuted, onTap: () => _showMockNotImplemented(context, 'App Settings')),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── About section ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'About',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildSettingsRow(Icons.help_outline_rounded, 'Help & Support', null, AppColors.textMuted, onTap: () => _showMockNotImplemented(context, 'Help & Support')),
                          _buildDivider(),
                          _buildSettingsRow(Icons.privacy_tip_outlined, 'Privacy Policy', null, AppColors.textMuted, onTap: () => _showMockNotImplemented(context, 'Privacy Policy')),
                          _buildDivider(),
                          _buildSettingsRow(Icons.description_outlined, 'Terms of Service', null, AppColors.textMuted, onTap: () => _showMockNotImplemented(context, 'Terms of Service')),
                          _buildDivider(),
                          _buildSettingsRow(Icons.schedule_rounded, 'Version 1.0.0', null, AppColors.textMuted, onTap: () => _showMockNotImplemented(context, 'Version Details')),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          NaviHerBottomNav(currentIndex: navIndex, onTap: onNavTap),
        ],
      ),
    );
  }

  void _showMockNotImplemented(BuildContext context, String item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('[Demo] $item is a prototype placeholder.'),
        backgroundColor: AppColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildVertDivider() {
    return Container(width: 1, color: AppColors.border);
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: AppColors.border, indent: 56);
  }

  Widget _buildSettingsRow(IconData icon, String title, String? subtitle, Color iconColor, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
