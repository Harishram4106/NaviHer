import 'package:flutter/material.dart';

/// NaviHer Design System — Dark Premium Color System
/// All colors strictly derived from reference screenshots.
/// Deep navy backgrounds, pink/magenta accent, muted text on dark surfaces.
abstract class AppColors {
  // ─── Primary Backgrounds ─────────────────────────────────────────────────────
  /// Main screen background: near-black navy #0D0F1A
  static const Color background = Color(0xFF0D0F1A);

  /// Slightly elevated surface (cards, sheets): #161929
  static const Color surface = Color(0xFF161929);

  /// Elevated cards above surface: #1E2235
  static const Color surfaceElevated = Color(0xFF1E2235);

  /// Highest elevation (popovers, tooltips): #252840
  static const Color surfaceHigh = Color(0xFF252840);

  // ─── NaviHer Brand ───────────────────────────────────────────────────────────
  /// Primary accent — NaviHer pink/magenta
  static const Color primaryPink = Color(0xFFE91E8C);

  /// Secondary accent — restrained purple
  static const Color secondaryPurple = Color(0xFF7B61FF);

  static const Color accent = primaryPink;
  static const Color accentLight = Color(0xFFFF5CB4);
  static const Color accentDark = Color(0xFFBB1470);

  /// Translucent pink surface (active highlights)
  static const Color accentSurface = Color(0x1FE91E8C);

  /// Translucent purple surface
  static const Color secondarySurface = Color(0x1F7B61FF);

  // ─── Text (on dark surfaces) ─────────────────────────────────────────────────
  /// Primary text: white
  static const Color textPrimary = Colors.white;

  /// Secondary text: muted gray
  static const Color textSecondary = Color(0xFF9CA3AF);

  /// Muted/placeholder text
  static const Color textMuted = Color(0xFF6B7280);

  /// Disabled text
  static const Color textDisabled = Color(0xFF4B5563);

  // ─── Borders ────────────────────────────────────────────────────────────────
  /// Subtle dark border on dark surfaces
  static const Color border = Color(0xFF2D3250);

  /// Lighter border for inner separation
  static const Color borderLight = Color(0xFF374162);

  /// Pink accent border (selected states)
  static const Color borderAccent = Color(0x4DE91E8C);

  // ─── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successSurface = Color(0x2022C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0x20F59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSurface = Color(0x20EF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0x203B82F6);

  // ─── Map (dark theme) ────────────────────────────────────────────────────────
  /// Dark navy map background
  static const Color mapBackground = Color(0xFF151B2E);

  /// Dark road color (subtle lighter navy)
  static const Color mapRoad = Color(0xFF1E2845);

  /// Major road: slightly brighter
  static const Color mapMajorRoad = Color(0xFF2A3555);

  /// Highway: muted warm
  static const Color mapHighway = Color(0xFF334270);

  /// Safe zone highlight
  static const Color mapSafeZone = Color(0x3022C55E);

  static const Color mapOverlay = Color(0x66000000);

  // ─── Routes ─────────────────────────────────────────────────────────────────
  /// NaviHer Safe route: pink/magenta
  static const Color routeSafe = Color(0xFFE91E8C);

  /// Fastest route: muted gray/blue
  static const Color routeFastest = Color(0xFF64748B);

  static const Color routeSafeGlow = Color(0x60E91E8C);

  // ─── POI Markers ────────────────────────────────────────────────────────────
  static const Color poiPolice = Color(0xFF3B82F6);
  static const Color poiHospital = Color(0xFFEF4444);
  static const Color poiPharmacy = Color(0xFF22C55E);
  static const Color poiPublic = Color(0xFF7B61FF);

  // ─── Navigation Bar ─────────────────────────────────────────────────────────
  static const Color navActive = primaryPink;
  static const Color navInactive = Color(0xFF6B7280);

  // ─── Emergency ──────────────────────────────────────────────────────────────
  static const Color emergencyBackground = Color(0xFF0D0F1A);
  static const Color emergencyGlow = Color(0x60E91E8C);
  static const Color emergencyCallButton = Color(0xFFE91E8C);

  // ─── Safety ─────────────────────────────────────────────────────────────────
  static const Color safetyGreen = Color(0xFF22C55E);
  static const Color safetyGreenGlow = Color(0x4022C55E);
  static const Color riskLow = Color(0xFF22C55E);
  static const Color riskModerate = Color(0xFFF59E0B);
  static const Color riskHigh = Color(0xFFEF4444);
}
