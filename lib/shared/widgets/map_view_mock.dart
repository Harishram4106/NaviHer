import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import '../../core/theme/app_colors.dart';
import '../../features/demo/providers/demo_state_provider.dart';
import '../../core/models/route_model.dart';

class MapViewMock extends ConsumerStatefulWidget {
  final bool isNavigation;
  final bool isComparison;
  final int activeComparisonTab; // 0 = Safe, 1 = Fast

  const MapViewMock({
    super.key,
    this.isNavigation = false,
    this.isComparison = false,
    this.activeComparisonTab = 0,
  });

  @override
  ConsumerState<MapViewMock> createState() => _MapViewMockState();
}

class _MapViewMockState extends ConsumerState<MapViewMock> {
  final TransformationController _transformController = TransformationController();
  final double mapSize = 2400.0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recenter();
    });
  }
  
  void _zoomIn() {
    setState(() {
      _transformController.value = _transformController.value..scaleByVector3(Vector3(1.3, 1.3, 1.3));
    });
  }

  void _zoomOut() {
    setState(() {
      _transformController.value = _transformController.value..scaleByVector3(Vector3(1 / 1.3, 1 / 1.3, 1 / 1.3));
    });
  }

  void _recenter() {
    if (!mounted) return;
    setState(() {
      final size = MediaQuery.of(context).size;
      // Start slightly zoomed out to see the map
      final scale = 1.0;
      
      final demoState = ref.read(demoStateProvider);
      final navState = demoState.navigationState;
      
      // Calculate current location
      Offset target = Offset(mapSize * 0.35, mapSize * 0.70); // Default YOU
      if (widget.isNavigation) {
        if (navState == DemoNavigationState.hazardDetected || navState == DemoNavigationState.recalculating || navState == DemoNavigationState.alternativeProposed || navState == DemoNavigationState.alternativeAccepted) {
          target = Offset(mapSize * 0.40, mapSize * 0.50);
        } else {
          target = Offset(mapSize * 0.38, mapSize * 0.60);
        }
      }
      
      // Center the target on screen
      final dx = (size.width / 2) - (target.dx * scale);
      final dy = (size.height / 2) - (target.dy * scale) - (widget.isNavigation ? 150 : 0);
      
      _transformController.value = Matrix4.identity()..translateByVector3(Vector3(dx, dy, 0))..scaleByVector3(Vector3(scale, scale, scale));
    });
  }
  
  void _showMockDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryPink)),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final demoState = ref.watch(demoStateProvider);
    final navState = demoState.navigationState;
    final activeRoute = demoState.activeRoute;
    final hasCommunityReport = demoState.hasCommunityReport;
    
    final isSafeRouteActive = activeRoute == null || activeRoute.type == RoutePreference.naviherSafe; 
    
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _transformController,
          constrained: false,
          boundaryMargin: EdgeInsets.all(mapSize / 2),
          minScale: 0.1,
          maxScale: 4.0,
          child: SizedBox(
            width: mapSize,
            height: mapSize,
            child: CustomPaint(
              painter: _DeterministicMapPainter(
                isComparison: widget.isComparison,
                activeComparisonTab: widget.activeComparisonTab,
                isNavigation: widget.isNavigation,
                navState: navState,
                isSafeRouteActive: isSafeRouteActive,
                hasCommunityReport: hasCommunityReport,
              ),
            ),
          ),
        ),
        
        Positioned(
          right: 16,
          bottom: widget.isNavigation ? 220 : 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMapControl(Icons.add, _zoomIn),
              const SizedBox(height: 8),
              _buildMapControl(Icons.remove, _zoomOut),
              const SizedBox(height: 8),
              _buildMapControl(Icons.my_location, _recenter),
            ],
          ),
        ),
        
        if (widget.isNavigation || widget.isComparison) ...[
          _buildTapTarget(mapSize * 0.25, mapSize * 0.25, () => _showMockDialog('Police Station', 'Anna Nagar West Police Station.\nOpen 24/7.')),
          _buildTapTarget(mapSize * 0.85, mapSize * 0.40, () => _showMockDialog('Hospital', 'Sundaram Medical Foundation.\nEmergency services available.')),
          _buildTapTarget(mapSize * 0.15, mapSize * 0.55, () => _showMockDialog('Pharmacy', 'Apollo Pharmacy.\nOpen 24 hours.')),
          _buildTapTarget(mapSize * 0.50, mapSize * 0.55, () => _showMockDialog('Safe Spot', 'Community Center.\nWell lit area.')),
        ],
        
        if ((widget.isNavigation) && 
            (navState == DemoNavigationState.hazardDetected || 
             navState == DemoNavigationState.recalculating || 
             navState == DemoNavigationState.alternativeProposed || 
             navState == DemoNavigationState.alternativeAccepted))
          _buildTapTarget(mapSize * 0.55, mapSize * 0.45, () => _showMockDialog('Hazard', 'Road Construction reported 10 mins ago.\nHigh disruption.')),
      ],
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildTapTarget(double x, double y, VoidCallback onTap) {
    return AnimatedBuilder(
      animation: _transformController,
      builder: (context, child) {
        final pos = _transformController.value.transform3(Vector3(x, y, 0));
        return Positioned(
          left: pos.x - 25,
          top: pos.y - 25,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.transparent,
            ),
          ),
        );
      }
    );
  }
}

class _DeterministicMapPainter extends CustomPainter {
  final bool isComparison;
  final int activeComparisonTab;
  final bool isNavigation;
  final DemoNavigationState navState;
  final bool isSafeRouteActive;
  final bool hasCommunityReport;

  const _DeterministicMapPainter({
    required this.isComparison,
    required this.activeComparisonTab,
    required this.isNavigation,
    required this.navState,
    required this.isSafeRouteActive,
    this.hasCommunityReport = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0F121C),
    );

    _drawParks(canvas, size);
    _drawCityBlocks(canvas, size);
    _drawSecondaryRoads(canvas, size);
    _drawMajorRoads(canvas, size);
    _drawRoadLabels(canvas, size);
    _drawAreaNames(canvas, size);

    if (isComparison) {
      _drawSafetyCorridor(canvas, size);
      _drawFastRoute(canvas, size, isActive: activeComparisonTab == 1);
      _drawSafeRoute(canvas, size, isActive: activeComparisonTab == 0);
    } else if (isNavigation) {
      if (isSafeRouteActive) {
        _drawSafetyCorridor(canvas, size);
        
        if (navState == DemoNavigationState.alternativeAccepted) {
          _drawAlternativeRoute(canvas, size);
        } else {
          _drawSafeRoute(canvas, size, isActive: true);
        }
      } else {
        _drawFastRoute(canvas, size, isActive: true);
      }
    }

    _drawPois(canvas, size);
    _drawMarkers(canvas, size);

    if (hasCommunityReport) {
      _drawHazard(canvas, Offset(size.width * 0.70, size.width * 0.40));
    }
  }

  void _drawParks(Canvas canvas, Size size) {
    final parkPaint = Paint()..color = const Color(0xFF132A24).withValues(alpha: 0.6)..style = PaintingStyle.fill;
    
    final p1 = Path()
      ..moveTo(size.width * 0.35, size.height * 0.20)
      ..lineTo(size.width * 0.50, size.height * 0.22)
      ..lineTo(size.width * 0.48, size.height * 0.35)
      ..lineTo(size.width * 0.30, size.height * 0.32)
      ..close();
      
    final p2 = Path()
      ..moveTo(size.width * 0.75, size.height * 0.60)
      ..lineTo(size.width * 0.90, size.height * 0.65)
      ..lineTo(size.width * 0.85, size.height * 0.80)
      ..lineTo(size.width * 0.70, size.height * 0.75)
      ..close();
      
    final p3 = Path()
      ..moveTo(size.width * 0.40, size.height * 0.45)
      ..lineTo(size.width * 0.55, size.height * 0.48)
      ..lineTo(size.width * 0.60, size.height * 0.60)
      ..lineTo(size.width * 0.42, size.height * 0.58)
      ..close();
      
    canvas.drawPath(p1, parkPaint);
    canvas.drawPath(p2, parkPaint);
    canvas.drawPath(p3, parkPaint);
    
    _drawText(canvas, 'Park', size.width * 0.41, size.height * 0.27, const Color(0xFF1E5040), 18, isBold: true);
    _drawText(canvas, 'Kendriya\nVidyalaya', size.width * 0.50, size.height * 0.53, const Color(0xFF1E5040), 16, isBold: true, align: TextAlign.center);
  }

  void _drawCityBlocks(Canvas canvas, Size size) {
    final blockPaint = Paint()..color = const Color(0xFF181C28).withValues(alpha: 0.8)..style = PaintingStyle.fill;
    
    final p1 = Path()..addRect(Rect.fromLTRB(size.width*0.1, size.height*0.1, size.width*0.3, size.height*0.18));
    final p2 = Path()..addRect(Rect.fromLTRB(size.width*0.6, size.height*0.2, size.width*0.8, size.height*0.35));
    final p3 = Path()..addRect(Rect.fromLTRB(size.width*0.1, size.height*0.4, size.width*0.35, size.height*0.6));
    final p4 = Path()..addRect(Rect.fromLTRB(size.width*0.65, size.height*0.65, size.width*0.9, size.height*0.9));
    
    canvas.drawPath(p1, blockPaint);
    canvas.drawPath(p2, blockPaint);
    canvas.drawPath(p3, blockPaint);
    canvas.drawPath(p4, blockPaint);
  }

  void _drawSecondaryRoads(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A3041).withValues(alpha: 0.8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
      
    for (int i=1; i<40; i++) {
      double y1 = size.height * (i * 0.025);
      double y2 = size.height * (i * 0.025) + size.height * 0.025;
      canvas.drawLine(Offset(0, y1), Offset(size.width, y2), paint);
      canvas.drawLine(Offset(0, y1 + size.height*0.01), Offset(size.width, y2 - size.height*0.01), paint);
    }
    
    for (int i=1; i<40; i++) {
      double x1 = size.width * (i * 0.025);
      double x2 = x1 - size.width * 0.04;
      canvas.drawLine(Offset(x1, 0), Offset(x2, size.height), paint);
    }
  }

  void _drawMajorRoads(Canvas canvas, Size size) {
    final majorPaintOuter = Paint()
      ..color = const Color(0xFF1E2333)
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    final majorPaintInner = Paint()
      ..color = const Color(0xFF333B52)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mainRoad = Path()
      ..moveTo(size.width * 0.65, 0)
      ..quadraticBezierTo(size.width * 0.60, size.height * 0.40, size.width * 0.60, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.60, size.height * 0.70, size.width * 0.35, size.height);
      
    final annaRoad = Path()
      ..moveTo(0, size.height * 0.30)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.35, size.width, size.height * 0.20);
      
    final seventhAve = Path()
      ..moveTo(0, size.height * 0.50)
      ..lineTo(size.width * 0.55, size.height * 0.65);
      
    final secondAve = Path()
      ..moveTo(size.width * 0.20, size.height)
      ..lineTo(size.width * 0.90, size.height * 0.60);

    for (final p in [mainRoad, annaRoad, seventhAve, secondAve]) {
      canvas.drawPath(p, majorPaintOuter);
      canvas.drawPath(p, majorPaintInner);
    }
  }
  
  void _drawRoadLabels(Canvas canvas, Size size) {
    _drawAngledText(canvas, 'Main Road', size.width * 0.63, size.height * 0.20, -1.3, 16, const Color(0xFF8B9CB5));
    _drawAngledText(canvas, 'Anna Nagar Main Road', size.width * 0.25, size.height * 0.30, 0.1, 16, const Color(0xFF8B9CB5));
    _drawAngledText(canvas, '7th Avenue', size.width * 0.20, size.height * 0.53, 0.25, 14, const Color(0xFF8B9CB5));
    _drawAngledText(canvas, '2nd Ave', size.width * 0.60, size.height * 0.79, -0.5, 14, const Color(0xFF8B9CB5));
    _drawAngledText(canvas, '12th Main Rd', size.width * 0.15, size.height * 0.65, -0.1, 14, const Color(0xFF6B7A94));
  }

  void _drawAngledText(Canvas canvas, String text, double x, double y, double rotationAngle, double fontSize, Color color) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotationAngle);
    _drawText(canvas, text, 0, 0, color, fontSize, isBold: true);
    canvas.restore();
  }

  void _drawAreaNames(Canvas canvas, Size size) {
    _drawText(canvas, 'Anna Nagar', size.width * 0.30, size.height * 0.23, const Color(0xFF9CA9C2), 26, isBold: true);
    _drawText(canvas, 'Shenoy Nagar', size.width * 0.80, size.height * 0.55, const Color(0xFF9CA9C2), 26, isBold: true);
    _drawText(canvas, 'Thirumangalam', size.width * 0.20, size.height * 0.85, const Color(0xFF9CA9C2), 22, isBold: true);
  }

  void _drawText(Canvas canvas, String text, double x, double y, Color color, double fontSize, {bool isBold = false, TextAlign align = TextAlign.left}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: isBold ? FontWeight.w800 : FontWeight.w400, height: 1.2)),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    tp.paint(canvas, Offset(x - (align == TextAlign.center ? tp.width/2 : 0), y - tp.height / 2));
  }
  
  Path _getSafeRoutePath(Size size) {
    return Path()
      ..moveTo(size.width * 0.35, size.height * 0.70) // YOU
      ..lineTo(size.width * 0.48, size.height * 0.63)
      ..quadraticBezierTo(size.width * 0.52, size.height * 0.61, size.width * 0.54, size.height * 0.57)
      ..lineTo(size.width * 0.59, size.height * 0.48)
      ..quadraticBezierTo(size.width * 0.60, size.height * 0.45, size.width * 0.60, size.height * 0.40)
      ..lineTo(size.width * 0.62, size.height * 0.20)
      ..lineTo(size.width * 0.75, size.height * 0.10); // DEST
  }
  
  Path _getAlternativeRoutePath(Size size) {
    return Path()
      ..moveTo(size.width * 0.35, size.height * 0.70) // YOU
      ..lineTo(size.width * 0.35, size.height * 0.60) // detour
      ..lineTo(size.width * 0.32, size.height * 0.40) 
      ..lineTo(size.width * 0.45, size.height * 0.32) 
      ..lineTo(size.width * 0.61, size.height * 0.25) // rejoin
      ..lineTo(size.width * 0.62, size.height * 0.20)
      ..lineTo(size.width * 0.75, size.height * 0.10); // DEST
  }

  Path _getFastRoutePath(Size size) {
    return Path()
      ..moveTo(size.width * 0.35, size.height * 0.70) // YOU
      ..lineTo(size.width * 0.70, size.height * 0.68)
      ..lineTo(size.width * 0.75, size.height * 0.40)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.10); // DEST
  }

  void _drawSafetyCorridor(Canvas canvas, Size size) {
    final corridorPaint = Paint()
      ..color = AppColors.safetyGreen.withValues(alpha: 0.15)
      ..strokeWidth = 140 
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final path = _getSafeRoutePath(size);
    canvas.drawPath(path, corridorPaint);
    
    final simpleBoundaryPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final boundary = Path()
      ..moveTo(size.width * 0.25, size.height * 0.75)
      ..lineTo(size.width * 0.20, size.height * 0.50)
      ..lineTo(size.width * 0.40, size.height * 0.25)
      ..lineTo(size.width * 0.65, size.height * 0.35)
      ..lineTo(size.width * 0.70, size.height * 0.60)
      ..close();
      
    _drawDashedPath(canvas, boundary, simpleBoundaryPaint);
    
    _drawSafeCorridorBadge(canvas, Offset(size.width * 0.35, size.height * 0.35), 'Safe Corridor');
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 15), paint);
        distance += 25;
      }
    }
  }

  void _drawSafeCorridorBadge(Canvas canvas, Offset center, String text) {
    final paint = Paint()..color = AppColors.primaryPink..style = PaintingStyle.fill;
    final rect = RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 140, height: 40), const Radius.circular(20));
    canvas.drawRRect(rect, paint);

    final tp = TextPainter(
      text: TextSpan(text: '🛡 $text', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr, textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawSafeRoute(Canvas canvas, Size size, {required bool isActive}) {
    final path = _getSafeRoutePath(size);
    
    // 1. Shadow / Casing
    canvas.drawPath(path, Paint()
      ..color = Colors.black.withValues(alpha: isActive ? 0.6 : 0.2)
      ..strokeWidth = isActive ? 34 : 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    // 2. Soft Magenta Glow
    canvas.drawPath(path, Paint()
      ..color = AppColors.routeSafe.withValues(alpha: isActive ? 0.6 : 0.2)
      ..strokeWidth = isActive ? 28 : 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));

    // 3. Bright Magenta Route
    canvas.drawPath(path, Paint()
      ..color = isActive ? const Color(0xFFFF5AAA) : AppColors.routeSafe.withValues(alpha: 0.5)
      ..strokeWidth = isActive ? 16 : 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke);
      
    if (isActive) _drawDirectionArrow(canvas, Offset(size.width * 0.54, size.height * 0.57), -0.7);
  }

  void _drawFastRoute(Canvas canvas, Size size, {required bool isActive}) {
    final path = _getFastRoutePath(size);
    final color = const Color(0xFF2A84FF);
    
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: isActive ? 0.6 : 0.3)
      ..strokeWidth = isActive ? 20 : 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    canvas.drawPath(path, Paint()
      ..color = isActive ? const Color(0xFF5A9FFF) : color.withValues(alpha: 0.5)
      ..strokeWidth = isActive ? 12 : 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke);
      
    if (!isActive) {
      final dashPaint = Paint()
        ..color = const Color(0xFF2A84FF).withValues(alpha: 0.8)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      _drawDashedPath(canvas, path, dashPaint);
    }
  }

  void _drawAlternativeRoute(Canvas canvas, Size size) {
    final path = _getAlternativeRoutePath(size);
    final color = const Color(0xFF2A84FF);
    
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    final dashPaint = Paint()
      ..color = const Color(0xFF5A9FFF)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    _drawDashedPath(canvas, path, dashPaint);
    
    _drawSafeCorridorBadge(canvas, Offset(size.width * 0.50, size.height * 0.32), 'Alternative\n+4 min');
  }

  void _drawDirectionArrow(Canvas canvas, Offset position, double rotation) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);
    
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, -12)
      ..lineTo(10, 12)
      ..lineTo(0, 6)
      ..lineTo(-10, 12)
      ..close();
      
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawMarkers(Canvas canvas, Size size) {
    Offset currentLocation = Offset(size.width * 0.35, size.height * 0.70);
    final destination = Offset(size.width * 0.75, size.height * 0.10);
    
    if (isNavigation) {
      if (navState == DemoNavigationState.hazardDetected || navState == DemoNavigationState.recalculating || navState == DemoNavigationState.alternativeProposed || navState == DemoNavigationState.alternativeAccepted) {
        currentLocation = Offset(size.width * 0.40, size.height * 0.50); 
        _drawHazard(canvas, Offset(size.width * 0.55, size.height * 0.45)); 
      } else {
        currentLocation = Offset(size.width * 0.38, size.height * 0.60); 
      }
    }

    _drawLocationDot(canvas, currentLocation, const Color(0xFF2A84FF)); 
    _drawMarkerLabel(canvas, currentLocation.translate(0, 45), 'You', const Color(0xFF5A9FFF));

    _drawPinMarker(canvas, destination, AppColors.primaryPink);
    _drawMarkerLabel(canvas, destination.translate(0, 45), 'VR Mall', Colors.white);
  }
  
  void _drawMarkerLabel(Canvas canvas, Offset center, String text, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawLocationDot(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 60, Paint()..color = color.withValues(alpha: 0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20));
    canvas.drawCircle(center, 30, Paint()..color = color.withValues(alpha: 0.4));
    canvas.drawCircle(center, 18, Paint()..color = color);
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);
  }

  void _drawPinMarker(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 40, Paint()..color = color.withValues(alpha: 0.3)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));
    canvas.drawCircle(center, 24, Paint()..color = color);
    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
  }

  void _drawHazard(Canvas canvas, Offset center) {
    final boxPaint = Paint()
      ..color = AppColors.surfaceElevated.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final boxBorder = Paint()
      ..color = AppColors.warning.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final rect = RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 220, height: 70), const Radius.circular(16));
    canvas.drawRRect(rect, boxPaint);
    canvas.drawRRect(rect, boxBorder);
    
    final iconTp = TextPainter(text: const TextSpan(text: '⚠', style: TextStyle(color: AppColors.warning, fontSize: 32)), textDirection: TextDirection.ltr)..layout();
    iconTp.paint(canvas, Offset(center.dx - 80, center.dy - iconTp.height/2));
    
    final textTp = TextPainter(text: const TextSpan(text: 'Road Work\n350 m', style: TextStyle(color: Colors.white, fontSize: 16, height: 1.2, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    textTp.paint(canvas, Offset(center.dx - 30, center.dy - textTp.height/2));
  }

  void _drawPois(Canvas canvas, Size size) {
    _drawPoiMarker(canvas, Offset(size.width * 0.25, size.width * 0.25), const Color(0xFF2A84FF), '🛡', 'Police\n0.8 km');
    _drawPoiMarker(canvas, Offset(size.width * 0.85, size.height * 0.40), const Color(0xFFFF4B4B), '✚', 'Hospital\n1.2 km');
    _drawPoiMarker(canvas, Offset(size.width * 0.15, size.height * 0.55), const Color(0xFFA838FF), '⚕', 'Pharmacy\n0.9 km');
    _drawPoiMarker(canvas, Offset(size.width * 0.50, size.height * 0.55), const Color(0xFF2DCE89), '●', 'Community Center\n0.6 km');
  }

  void _drawPoiMarker(Canvas canvas, Offset center, Color color, String icon, String label) {
    canvas.drawCircle(center, 35, Paint()..color = color.withValues(alpha: 0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    canvas.drawCircle(center, 28, Paint()..color = AppColors.surfaceElevated);
    canvas.drawCircle(center, 24, Paint()..color = color);
    
    final tp = TextPainter(
      text: TextSpan(text: icon, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
    
    final labelTp = TextPainter(
      text: TextSpan(text: label, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w500, height: 1.2)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    labelTp.paint(canvas, Offset(center.dx - labelTp.width / 2, center.dy + 35));
  }

  @override
  bool shouldRepaint(covariant _DeterministicMapPainter old) =>
      old.isComparison != isComparison ||
      old.activeComparisonTab != activeComparisonTab ||
      old.isNavigation != isNavigation ||
      old.navState != navState ||
      old.isSafeRouteActive != isSafeRouteActive ||
      old.hasCommunityReport != hasCommunityReport;
}
