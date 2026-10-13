import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0D2E), // Deep purple-black
      body: Stack(
        children: [
          // Full-screen background illustration
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_illustration.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => _buildFallbackBackground(size),
            ),
          ),

          // Dark gradient overlay — bottom fade to dark
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.40, 0.75, 1.0],
                  colors: [
                    Color(0x331A0D2E),
                    Color(0x001A0D2E),
                    Color(0x990D0918),
                    Color(0xDD0D0918),
                  ],
                ),
              ),
            ),
          ),

          // Logo + wordmark + slogan — centered upper area
          Positioned(
            top: size.height * 0.18, // Pushed down slightly to center the larger group
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NaviHer pin-heart icon mark
                  _buildLogoMark(),
                  const SizedBox(height: 8),
                  // "NaviHer" wordmark
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Navi',
                          style: GoogleFonts.inter(
                            fontSize: 48, // Slightly larger to match reference prominence
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Her',
                          style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryPink,
                            letterSpacing: -1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SAFER JOURNEYS\nBRIGHTER TOMORROWS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 2.0,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Subtle visual separator
                  Container(
                    width: 32,
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 20),
                  // Stronger Safer Together
                  Text(
                    'Stronger\nSafer\nTogether ♡',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryPink,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom section — loading indicator + caption
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pink arc loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 3.0,
                      color: AppColors.primaryPink,
                      backgroundColor: AppColors.primaryPink.withValues(alpha: 0.20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Building safer communities together',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                      letterSpacing: 0.2,
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

  /// NaviHer logo mark: location pin with heart inside, pink fill
  Widget _buildLogoMark() {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(painter: _LogoMarkPainter()),
    );
  }

  Widget _buildFallbackBackground(Size size) {
    // Fallback: simulated cityscape at night
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D1B4E), // Deep purple
            Color(0xFF1A0D2E), // Near-black purple
            Color(0xFF0D0918), // Almost black
          ],
        ),
      ),
      child: CustomPaint(
        painter: _CityscapePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Paints a NaviHer logo mark: teardrop pin shape with heart cutout, pink fill
class _LogoMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer glow
    canvas.drawCircle(
      Offset(cx, cy * 0.85),
      size.width * 0.40,
      Paint()
        ..color = AppColors.primaryPink.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Pin body path (teardrop shape)
    final pinPaint = Paint()
      ..color = AppColors.primaryPink
      ..style = PaintingStyle.fill;

    final path = Path();
    final r = size.width * 0.38;
    final topCy = cy * 0.72;

    // Circle top
    path.addOval(Rect.fromCircle(center: Offset(cx, topCy), radius: r));
    // Teardrop point at bottom
    path.moveTo(cx - r * 0.45, topCy + r * 0.7);
    path.quadraticBezierTo(cx, topCy + r * 2.0, cx, topCy + r * 2.0);
    path.quadraticBezierTo(cx, topCy + r * 2.0, cx + r * 0.45, topCy + r * 0.7);
    path.close();

    canvas.drawPath(path, pinPaint);

    // White heart inside
    _drawHeart(canvas, Offset(cx, topCy), size.width * 0.20);
  }

  void _drawHeart(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final s = size;
    final x = center.dx;
    final y = center.dy;

    path.moveTo(x, y + s * 0.35);
    path.cubicTo(x, y, x - s, y, x - s, y - s * 0.35);
    path.cubicTo(x - s, y - s * 0.75, x - s * 0.5, y - s, x, y - s * 0.5);
    path.cubicTo(x + s * 0.5, y - s, x + s, y - s * 0.75, x + s, y - s * 0.35);
    path.cubicTo(x + s, y, x, y, x, y + s * 0.35);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fallback cityscape silhouette painter
class _CityscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildingPaint = Paint()
      ..color = const Color(0xFF1E0F35)
      ..style = PaintingStyle.fill;

    // Simple building silhouettes
    final buildings = [
      Rect.fromLTWH(0, size.height * 0.60, size.width * 0.08, size.height * 0.40),
      Rect.fromLTWH(size.width * 0.06, size.height * 0.50, size.width * 0.10, size.height * 0.50),
      Rect.fromLTWH(size.width * 0.15, size.height * 0.45, size.width * 0.09, size.height * 0.55),
      Rect.fromLTWH(size.width * 0.23, size.height * 0.55, size.width * 0.12, size.height * 0.45),
      Rect.fromLTWH(size.width * 0.34, size.height * 0.48, size.width * 0.08, size.height * 0.52),
      Rect.fromLTWH(size.width * 0.42, size.height * 0.56, size.width * 0.10, size.height * 0.44),
      Rect.fromLTWH(size.width * 0.51, size.height * 0.42, size.width * 0.11, size.height * 0.58),
      Rect.fromLTWH(size.width * 0.61, size.height * 0.52, size.width * 0.09, size.height * 0.48),
      Rect.fromLTWH(size.width * 0.69, size.height * 0.46, size.width * 0.12, size.height * 0.54),
      Rect.fromLTWH(size.width * 0.80, size.height * 0.53, size.width * 0.08, size.height * 0.47),
      Rect.fromLTWH(size.width * 0.87, size.height * 0.60, size.width * 0.13, size.height * 0.40),
    ];

    for (final b in buildings) {
      canvas.drawRect(b, buildingPaint);
    }

    // Street lights — warm amber dots
    final lightPaint = Paint()
      ..color = const Color(0xFFFFB347).withValues(alpha: 0.60)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    for (int i = 0; i < 8; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.08 + i * 0.12), size.height * 0.72),
        6,
        lightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
