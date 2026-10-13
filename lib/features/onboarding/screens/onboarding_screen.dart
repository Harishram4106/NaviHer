import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'Navigate\nSafer, ',
      titleHighlight: 'Together',
      description:
          'Get safer route recommendations,\nreal-time safety insights, and a supportive\ncommunity wherever you go.',
      features: [
        _Feature(icon: Icons.shield_rounded, label: 'Safer\nRoutes', color: Color(0xFF7B61FF)),
        _Feature(icon: Icons.location_on_rounded, label: 'Supportive\nCommunity', color: Color(0xFFE91E8C)),
        _Feature(icon: Icons.bar_chart_rounded, label: 'Real-Time\nSafety Insights', color: Color(0xFF7B61FF)),
      ],
    ),
    _OnboardingPage(
      title: 'Stay\nConnected, ',
      titleHighlight: 'Stay Safe',
      description:
          'Share your live location with trusted contacts\nand get instant SOS alerts when you need help.',
      features: [
        _Feature(icon: Icons.group_rounded, label: 'Trusted\nContacts', color: Color(0xFF7B61FF)),
        _Feature(icon: Icons.sos_rounded, label: 'SOS\nAlerts', color: Color(0xFFE91E8C)),
        _Feature(icon: Icons.share_location_rounded, label: 'Live\nLocation', color: Color(0xFF7B61FF)),
      ],
    ),
    _OnboardingPage(
      title: 'Community\n',
      titleHighlight: 'Reports',
      description:
          'Report unsafe areas and help others stay\nsafe. Together we build safer streets.',
      features: [
        _Feature(icon: Icons.report_rounded, label: 'Report\nIncidents', color: Color(0xFF7B61FF)),
        _Feature(icon: Icons.map_rounded, label: 'Safety\nMap', color: Color(0xFFE91E8C)),
        _Feature(icon: Icons.notifications_rounded, label: 'Real-Time\nAlerts', color: Color(0xFF7B61FF)),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background subtle gradient (dark navy top to slightly lighter)
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1635), Color(0xFF0D0F1A)],
                ),
              ),
            ),
          ),

          // Skip button top-right
          Positioned(
            top: topPad + 16,
            right: 24,
            child: GestureDetector(
              onTap: widget.onComplete,
              child: Text(
                'Skip',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPink,
                ),
              ),
            ),
          ),

          // Main page content
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final p = _pages[index];
                return _buildPageContent(context, p, size, topPad);
              },
            ),
          ),

          // Bottom bar: dots + Next button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pagination dots
                Row(
                  children: List.generate(_pages.length, (i) {
                    final isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 6),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primaryPink : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                // Next button — pink pill with arrow
                GestureDetector(
                  onTap: _onNext,
                  child: Container(
                    width: size.width * 0.58,
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
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, _OnboardingPage page, Size size, double topPad) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: size.height,
        child: Column(
          children: [
            SizedBox(height: topPad + 60),

            // Illustration
            SizedBox(
              height: size.height * 0.32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background subtle radial glow
                  Container(
                    width: size.width * 0.78,
                    height: size.height * 0.32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.secondaryPurple.withValues(alpha: 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.30,
                    child: Image.asset(
                      'assets/images/onboarding_illustration.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => _buildFallbackIllustration(size),
                    ),
                  ),

                  // Feature pills floating around illustration
                  Positioned(
                    top: size.height * 0.02,
                    left: 12,
                    child: _buildFeaturePill(page.features[0]),
                  ),
                  Positioned(
                    top: size.height * 0.09,
                    right: 8,
                    child: _buildFeaturePill(page.features[1]),
                  ),
                  Positioned(
                    bottom: size.height * 0.01,
                    right: 16,
                    child: _buildFeaturePill(page.features[2]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: page.title,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: page.titleHighlight,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryPink,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                page.description,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePill(_Feature feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 120),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(feature.icon, color: feature.color, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            feature.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIllustration(Size size) {
    // Woman with phone silhouette (painted)
    return SizedBox(
      height: size.height * 0.30,
      child: CustomPaint(painter: _WomanIllustrationPainter()),
    );
  }
}

class _WomanIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B61FF).withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;

    // Simple silhouette
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.22),
          width: 60,
          height: 60),
      paint..color = const Color(0xFF9B7CA0),
    );
    final bodyPaint = Paint()
      ..color = const Color(0xFF6B5580)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height * 0.60),
            width: 80,
            height: size.height * 0.55),
        const Radius.circular(20),
      ),
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OnboardingPage {
  final String title;
  final String titleHighlight;
  final String description;
  final List<_Feature> features;

  const _OnboardingPage({
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.features,
  });
}

class _Feature {
  final IconData icon;
  final String label;
  final Color color;

  const _Feature({required this.icon, required this.label, required this.color});
}
