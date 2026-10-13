import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../providers/emergency_provider.dart';
import '../../demo/providers/demo_state_provider.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const EmergencyScreen({super.key, required this.onBack});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isEmergencyActive = false;
  double _slideValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleNotifyContacts() async {
    final contacts = ref.read(demoStateProvider).trustedContacts;
    await ref.read(emergencyProvider.notifier).notifyContacts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('[Demo] Alert prepared for ${contacts.length} trusted contacts.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.secondaryPurple,
        ),
      );
    }
  }

  void _handleShareLocation() async {
    ref.read(demoStateProvider.notifier).toggleLocationSharing(true);
    await ref.read(emergencyProvider.notifier).shareLiveLocation();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('[Demo] Live location sharing simulation started.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.primaryPink,
        ),
      );
    }
  }

  void _handleMockNotImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('[Demo] Action not implemented in prototype.', style: GoogleFonts.inter()),
        backgroundColor: AppColors.surfaceElevated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    if (_isEmergencyActive) {
      return Scaffold(
        backgroundColor: AppColors.danger,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, child) => Transform.scale(
                  scale: _pulseAnimation.value * 1.2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2)),
                    child: const Icon(Icons.warning_rounded, color: Colors.white, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('EMERGENCY MODE ACTIVE', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Text('LOCATION SHARING — SIMULATED\nPrototype alert sent to contacts.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: Colors.white70, height: 1.5)),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEmergencyActive = false;
                    _slideValue = 0.0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text('Deactivate Emergency', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.danger)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: topPad + 12),

                  // ── App bar ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onBack,
                          child: GlassContainer.neutral(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.zero,
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        GlassContainer.custom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          backgroundColor: AppColors.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderColor: AppColors.danger.withValues(alpha: 0.40),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Emergency Mode',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Title ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Emergency ',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'Mode',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryPink,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Get help quickly. You are not alone.',
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── SOS pulsing button ───────────────────────────────
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, child) => Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryPink.withValues(alpha: 0.10),
                              ),
                            ),
                            // Middle ring
                            Container(
                              width: 148,
                              height: 148,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryPink.withValues(alpha: 0.22),
                              ),
                            ),
                            // Core pink circle
                            Container(
                              width: 116,
                              height: 116,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [Color(0xFFFF4DA6), Color(0xFFE91E8C)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPink.withValues(alpha: 0.55),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.phone_rounded, color: Colors.white, size: 30),
                                  const SizedBox(height: 4),
                                  Text(
                                    'SOS',
                                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                                  ),
                                  Text(
                                    'Tap and hold\nfor 3 seconds',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(fontSize: 10, color: Colors.white70, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── 2x2 Action cards ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionCard(
                                Icons.shield_rounded,
                                'Call Emergency',
                                '112 · Police · Ambulance',
                                AppColors.primaryPink,
                                onTap: _handleMockNotImplemented,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionCard(
                                Icons.location_on_rounded,
                                'Share Live Location',
                                'With trusted contacts',
                                AppColors.primaryPink,
                                onTap: _handleShareLocation,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionCard(
                                Icons.group_rounded,
                                'Notify Contacts',
                                'Send alerts instantly',
                                AppColors.secondaryPurple,
                                onTap: _handleNotifyContacts,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionCard(
                                Icons.videocam_rounded,
                                'Record & Share',
                                'Audio, video, photos',
                                AppColors.primaryPink,
                                onTap: _handleMockNotImplemented,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Location card ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer.neutral(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: AppColors.primaryPink, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Current Location',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                                Text(
                                  'Anna Nagar, Chennai',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                Text(
                                  'Lat: 13.0827, Long: 80.2707',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          GlassContainer.neutral(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh_rounded, color: AppColors.textSecondary, size: 15),
                                const SizedBox(width: 4),
                                Text('Update', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── I'm in Danger CTA ─────────────────────────────────────
          Container(
            color: AppColors.background,
            padding: EdgeInsets.fromLTRB(20, 12, 20, botPad + 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxSlide = constraints.maxWidth - 56;
                return GlassContainer.custom(
                  height: 56,
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderColor: AppColors.danger.withValues(alpha: 0.5),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Center(
                        child: Text(
                          'Slide to activate SOS >>',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.danger),
                        ),
                      ),
                      Positioned(
                        left: _slideValue,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _slideValue += details.delta.dx;
                              if (_slideValue < 0) _slideValue = 0;
                              if (_slideValue > maxSlide) _slideValue = maxSlide;
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            if (_slideValue > maxSlide * 0.8) {
                              setState(() {
                                _slideValue = maxSlide;
                                _isEmergencyActive = true;
                              });
                              ref.read(demoStateProvider.notifier).toggleLocationSharing(true);
                            } else {
                              setState(() {
                                _slideValue = 0;
                              });
                            }
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle, Color iconColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer.neutral(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
          ],
        ),
      ),
    );
  }
}

