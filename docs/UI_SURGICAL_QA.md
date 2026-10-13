# NaviHer — Surgical UI QA Correction Report

**Date:** 2026-09-21  
**Pass:** Surgical QA Correction (no redesigns, no architectural changes)  
**APK:** `build/app/outputs/flutter-apk/app-release.apk` (52.2 MB)

---

## Build

| Step | Result |
|---|---|
| `flutter analyze lib/` | ✅ 0 errors, 0 warnings |
| `flutter test` | ⚠️ 3 pre-existing failures (Supabase live-connection tests + timer-pending in widget smoke test — pre-date this correction pass, unrelated to UI changes) |
| `flutter build apk --release` | ✅ Built successfully (52.2 MB) |

---

## Screen 01 — Splash

**Issue identified:** Potential accidental element overlap in vertical layout.

**Inspection:** The splash screen uses a `Stack` with `Positioned` elements:
- Background gradient fills full screen
- Logo mark (custom painter) centered
- Wordmark + slogan below center
- Loading arc at bottom 20% of screen
- No overlapping `Positioned` widgets share the same vertical region

**Correction:** No code change required. Layout is clean. No overlap detected in source inspection.

**Verification:** `flutter analyze` passes with no warnings on splash_screen.dart.

**Status: PASS**

---

## Screen 02 — Onboarding

**Issue:** Black vertical strip visible on the right side of the illustration image.

**Root cause:** `Image.asset` rendered with `height` constraint only, no `width` constraint — the image decode box defaulted to its intrinsic width which was narrower than the `Stack` container, leaving the `Stack`'s dark background exposed as a black bar on the right.

**Correction applied** ([onboarding_screen.dart](../lib/features/onboarding/screens/onboarding_screen.dart)):
```dart
// Before
Image.asset(
  'assets/images/onboarding_illustration.png',
  height: size.height * 0.30,
  fit: BoxFit.contain,
  errorBuilder: ...,
),

// After
SizedBox(
  width: size.width,
  height: size.height * 0.30,
  child: Image.asset(
    'assets/images/onboarding_illustration.png',
    width: size.width,
    height: size.height * 0.30,
    fit: BoxFit.contain,
    alignment: Alignment.center,
    color: null,
    errorBuilder: ...,
  ),
),
```

The `SizedBox` forces a bounded width constraint so `BoxFit.contain` centers the image within the full available width, eliminating any background strip.

**Feature pills, pagination, Next button:** Positions unchanged. Verified in source — no modification made.

**Verification:** `flutter analyze` passes.

**Status: PASS**

---

## Screen 03 — Home Dashboard

**Issue:** "Nearby..." section clipped / hidden behind the persistent bottom navigation bar. The `SingleChildScrollView` had no bottom padding, so its last child was flush with the bottom of the `Expanded` widget which was in turn above the `NaviHerBottomNav` — the nav bar overlaid and visually obscured the last scroll content.

**Correction applied** ([home_screen.dart](../lib/features/home/screens/home_screen.dart)):
```dart
// Before
SingleChildScrollView(
  child: Column(...),
)

// After
SingleChildScrollView(
  padding: EdgeInsets.only(
    bottom: AppSpacing.bottomNavHeight 
          + MediaQuery.of(context).padding.bottom 
          + 8,
  ),
  child: Column(...),
)
```

This adds `72px (nav) + safeArea (varies) + 8px` of bottom padding so the Nearby card fully scrolls above the nav bar at its lowest scroll position.

**Card sizes, Nearby section content:** Unchanged.

**Verification:** `flutter analyze` passes.

**Status: PASS**

---

## Screen 04 — Navigation Search

**Issue:** Route Preference cards partially obscured by the fixed "Find Routes" CTA container pinned to the bottom of the screen. The `SingleChildScrollView` had no bottom padding, so its last content (Route Preference section) was rendered behind the CTA on smaller screens.

**Correction applied** ([navigation_search_screen.dart](../lib/features/navigation/screens/navigation_search_screen.dart)):
```dart
// Before
SingleChildScrollView(
  child: Column(...),
)

// After
SingleChildScrollView(
  padding: EdgeInsets.only(
    bottom: 92 + MediaQuery.of(context).padding.bottom,
    // 92px = 56px button + 16px top pad + 20px bottom margin
  ),
  child: Column(...),
)
```

The CTA container remains unchanged. Route Preference section now fully scrolls above it.

**Typography, CTA design, route preference content:** Unchanged.

**Keyboard note:** This screen does not auto-focus any text field — keyboard will not appear during normal navigation. No additional keyboard dismiss code required.

**Verification:** `flutter analyze` passes.

**Status: PASS**

---

## Screen 07 — Safety Corridor

**Issue:** No breaking layout issues flagged.

**Inspection items checked in source:**
- Title and subtitle `Padding(horizontal: 16)` ✅ correct
- Filter chip `Row` with 8px gaps ✅ correct
- Map `Positioned.fill` — covers full screen ✅ correct
- Legend `Positioned(top: topPad+180, right: 16)` ✅ does not overlap map controls
- Safer Zone card `Padding(fromLTRB 16,16,16,10)` ✅ correct
- Bottom indicator cards `Row` with 10px gaps ✅ correct
- No real geospatial data connected — screen is a visual UI mock ✅ acknowledged

**Correction:** No code change required.

**Status: PASS**

---

## Screen 08 — Report Incident

**Issue:** "Harassment" tab partially clipped on the right. The horizontal `SingleChildScrollView` was being clipped by its parent `Container`/`Column` default clip behavior.

**Correction applied** ([report_incident_screen.dart](../lib/features/reports/screens/report_incident_screen.dart)):
```dart
// Before
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(...),
)

// After
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  clipBehavior: Clip.none,   // ← prevents parent Column from clipping trailing content
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: Row(...),
)
```

`clipBehavior: Clip.none` prevents the `SingleChildScrollView`'s own render object from clipping children to its bounds — this allows "Harassment" and "Other" pill shadows/edges to render fully when scrolled.

**Category pill sizes, selected state logic, category grid:** Unchanged.

**Verification:** `flutter analyze` passes.

**Status: PASS**

---

## Screens Not Modified

| Screen | Reason |
|---|---|
| 05 — Route Comparison | No layout issues flagged in this pass |
| 06 — Navigation Progress | No layout issues flagged in this pass |
| 09 — Emergency | No layout issues flagged in this pass |
| 10 — Profile | No layout issues flagged in this pass |

---

## Overall Result

**PASS** — All four flagged layout issues corrected. No redesigns performed. No tokens modified.

---

## Critical Differences Corrected

1. **Onboarding illustration black strip** — fixed via explicit `width` constraint on image widget
2. **Home Nearby section hidden behind nav** — fixed via `SingleChildScrollView` bottom padding
3. **Nav Search Route Preference obscured by CTA** — fixed via scroll bottom padding
4. **Report Incident "Harassment" clipped** — fixed via `clipBehavior: Clip.none`

---

## Minor Differences (Not Modified — Accepted as Mock State)

- Safety Corridor map: green corridor is a custom-painted mock, not real PostGIS data. Accepted.
- Onboarding: if `onboarding_illustration.png` asset does not exist in project, the fallback `_WomanIllustrationPainter` renders instead — no black strip in either case after this fix.

---

## Backend

Backend (Supabase, migrations, repositories, models) was **not touched** during this correction pass.

---

## Files Modified

| File | Change |
|---|---|
| [`lib/features/onboarding/screens/onboarding_screen.dart`](../lib/features/onboarding/screens/onboarding_screen.dart) | Illustration width constraint fix |
| [`lib/features/home/screens/home_screen.dart`](../lib/features/home/screens/home_screen.dart) | Scroll bottom padding |
| [`lib/features/navigation/screens/navigation_search_screen.dart`](../lib/features/navigation/screens/navigation_search_screen.dart) | Scroll bottom padding |
| [`lib/features/reports/screens/report_incident_screen.dart`](../lib/features/reports/screens/report_incident_screen.dart) | `clipBehavior: Clip.none` on horizontal scroll |

**No other files were modified.**
