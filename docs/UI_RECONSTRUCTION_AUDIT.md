# UI Reconstruction Audit

## 1. Screen 1 — Splash
- **Existing Screen**: Splash Screen
- **Existing File**: `lib/features/onboarding/screens/splash_screen.dart`
- **Existing Route**: `/`
- **Existing Provider**: `authProvider` (checked during init)
- **Existing Repository**: `AuthRepository`
- **Backend Data Source**: Supabase Auth
- **Current Visual Implementation**: Basic Flutter scaffold with a logo and loading spinner (rebuilt to support Light Theme recently).
- **Reference Image**: `Pasted 2026-09-20 at 9.17.32 PM.png` (Image 1, Left)
- **Visual Mismatches**: Needs to strictly match the dark NaviHer background, exact logo placement, woman/traveler illustration, tagline, and bottom message from the reference.
- **Required Changes**: Update colors to match reference splash, add illustration asset, fix typography hierarchy.

## 2. Screen 2 — Onboarding
- **Existing Screen**: Onboarding Screen
- **Existing File**: `lib/features/onboarding/screens/onboarding_screen.dart`
- **Existing Route**: `/onboarding`
- **Existing Provider**: Local state (PageView)
- **Existing Repository**: None required for pure UI.
- **Backend Data Source**: None.
- **Current Visual Implementation**: Light Theme carousel with generic illustrations and buttons.
- **Reference Image**: `Pasted 2026-09-20 at 9.17.32 PM.png` (Image 1, Right)
- **Visual Mismatches**: Current uses Light Theme, reference uses dark background with pink/purple visual language. Needs specific "Skip", title, highlighted word treatment, route graphic, and badge indicators.
- **Required Changes**: Switch to reference's dark/accented theme for onboarding, match illustration styles, fix pagination indicators.

## 3. Screen 3 — Home Dashboard
- **Existing Screen**: Home Screen
- **Existing File**: `lib/features/home/screens/home_screen.dart`
- **Existing Route**: `/home`
- **Existing Provider**: `homeStateProvider`, `profileProvider`
- **Existing Repository**: `ProfileRepository`, Geospatial repositories.
- **Backend Data Source**: `profiles`, `road_segments` (for safety score).
- **Current Visual Implementation**: MapViewMock with a bottom sheet for search and quick actions.
- **Reference Image**: `Pasted 2026-09-20 at 9.17.41 PM.png` (Image 2, Left)
- **Visual Mismatches**: Reference has a specific greeting, avatar area, notification icon, prominent safety score, and nearby area information.
- **Required Changes**: Refactor layout to match exact greeting, safety status card, search field, and quick actions grid.

## 4. Screen 4 — Navigation Search
- **Existing Screen**: Navigation Search Screen
- **Existing File**: `lib/features/navigation/screens/navigation_search_screen.dart`
- **Existing Route**: `/search`
- **Existing Provider**: `navigationSearchProvider`
- **Existing Repository**: `GeocodingRepository` / `RouteRepository`
- **Backend Data Source**: Map APIs / PostGIS
- **Current Visual Implementation**: Two TextFields for From/To and buttons.
- **Reference Image**: `Pasted 2026-09-20 at 9.17.41 PM.png` (Image 2, Right)
- **Visual Mismatches**: Needs A/B markers, connector line, specific destination controls, travel context ("Going Home late?"), and Safe/Fastest route preference cards.
- **Required Changes**: Implement exact input field styling, side connector line, travel context chips, and specific route preference cards.

## 5. Screen 5 — Route Comparison
- **Existing Screen**: Route Comparison Screen
- **Existing File**: `lib/features/route_comparison/screens/route_comparison_screen.dart`
- **Existing Route**: `/route-comparison`
- **Existing Provider**: `routeComparisonProvider`
- **Existing Repository**: `RouteRepository`
- **Backend Data Source**: Routing engine / PostGIS
- **Current Visual Implementation**: List of routes overlaid on map.
- **Reference Image**: `Pasted 2026-09-20 at 9.17.51 PM.png` (Image 3, Left)
- **Visual Mismatches**: Requires specific route selection controls, map overlay with Safe/Fastest colors, travel time/distance layout, safety reasons, and risk indicators.
- **Required Changes**: Style route cards to exactly match the dual-option layout, add safety reason bullets and risk indicators.

## 6. Screen 6 — Navigation in Progress
- **Existing Screen**: Navigation Progress Screen
- **Existing File**: `lib/features/navigation/screens/navigation_progress_screen.dart`
- **Existing Route**: `/navigation`
- **Existing Provider**: `activeNavigationProvider`
- **Existing Repository**: `RouteRepository`
- **Backend Data Source**: Live tracking / PostGIS
- **Current Visual Implementation**: Map with top instruction banner and bottom summary sheet.
- **Reference Image**: `Pasted 2026-09-20 at 9.17.51 PM.png` (Image 3, Right)
- **Visual Mismatches**: Needs specific maneuver instruction card, map layout, safety control, report control, and bottom trip information (ETA, distance, End Trip).
- **Required Changes**: Restyle top maneuver card, add floating safety/report controls on the map.

## 7. Screen 7 — Safety Corridor
- **Existing Screen**: Safety Corridor Screen
- **Existing File**: `lib/features/safety_corridor/screens/safety_corridor_screen.dart`
- **Existing Route**: `/safety-corridor`
- **Existing Provider**: `safetyCorridorProvider`
- **Existing Repository**: `GeospatialRepository`
- **Backend Data Source**: `safety_features`, `points_of_interest`, `hazards`
- **Current Visual Implementation**: Basic map with colored zones and a legend.
- **Reference Image**: `Pasted 2026-09-20 at 9.18.01 PM.png` (Image 4, Left)
- **Visual Mismatches**: Needs specific title, information action, map overlay, detailed risk legend (Police, Hospital, Safer Area, Lighting, Activity, Help), and safety summary card.
- **Required Changes**: Rebuild legend and summary card to match reference exact UI components and iconography.

## 8. Screen 8 — Report Incident
- **Existing Screen**: Report Incident Screen
- **Existing File**: `lib/features/reports/screens/report_incident_screen.dart`
- **Existing Route**: `/report-incident`
- **Existing Provider**: `reportIncidentProvider`
- **Existing Repository**: `CommunityReportRepository`
- **Backend Data Source**: `community_reports`
- **Current Visual Implementation**: Dropdown for category and a text field.
- **Reference Image**: `Pasted 2026-09-20 at 9.18.01 PM.png` (Image 4, Right)
- **Visual Mismatches**: Needs specific incident category chips/cards, photo area, location display, anonymous toggle, and submit button.
- **Required Changes**: Replace dropdown with visual category cards, add exact photo upload placeholder and anonymous toggle design.

## 9. Screen 9 — Emergency Mode
- **Existing Screen**: Emergency Screen
- **Existing File**: `lib/features/emergency/screens/emergency_screen.dart`
- **Existing Route**: `/emergency`
- **Existing Provider**: `emergencyProvider`
- **Existing Repository**: `TrustedContactRepository`
- **Backend Data Source**: `trusted_contacts`, device APIs
- **Current Visual Implementation**: Red screen with a pulsing SOS button.
- **Reference Image**: `Pasted 2026-09-20 at 9.18.19 PM.png` (Image 5, Left)
- **Visual Mismatches**: Needs specific Emergency Mode heading, SOS button hold interaction visual, emergency actions (call, location share, trusted contacts, record audio).
- **Required Changes**: Add action buttons surrounding SOS, update SOS button styling, add location sharing indicator.

## 10. Screen 10 — Profile / Settings
- **Existing Screen**: Profile Screen
- **Existing File**: `lib/features/profile/screens/profile_screen.dart`
- **Existing Route**: `/profile`
- **Existing Provider**: `profileProvider`
- **Existing Repository**: `ProfileRepository`, `UserPreferencesRepository`
- **Backend Data Source**: `profiles`, `user_preferences`
- **Current Visual Implementation**: List of basic ListTile settings.
- **Reference Image**: `Pasted 2026-09-20 at 9.18.19 PM.png` (Image 5, Right)
- **Visual Mismatches**: Needs specific profile header, avatar, user info, edit action, safety statistics, and categorized sections (Personal Info, Trusted Contacts, Safety Preferences, App Settings, Help, Privacy, Terms, Version).
- **Required Changes**: Rebuild exact profile header, safety statistics widgets, and stylized list items.
