import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../repositories/auth_repository.dart';
import '../repositories/mock/mock_auth_repository.dart';
import '../repositories/supabase/supabase_auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/mock/mock_profile_repository.dart';
import '../repositories/supabase/supabase_profile_repository.dart';
import '../repositories/trusted_contacts_repository.dart';
import '../repositories/mock/mock_trusted_contacts_repository.dart';
import '../repositories/supabase/supabase_trusted_contacts_repository.dart';
import '../repositories/user_preferences_repository.dart';
import '../repositories/mock/mock_user_preferences_repository.dart';
import '../repositories/supabase/supabase_user_preferences_repository.dart';
import '../repositories/route_history_repository.dart';
import '../repositories/mock/mock_route_history_repository.dart';
import '../repositories/supabase/supabase_route_history_repository.dart';

import '../repositories/navigation_repository.dart';
import '../repositories/mock/mock_navigation_repository.dart';

import '../repositories/geospatial/road_segment_repository.dart';
import '../repositories/geospatial/safety_feature_repository.dart';
import '../repositories/geospatial/point_of_interest_repository.dart';
import '../repositories/geospatial/hazard_repository.dart';
import '../repositories/geospatial/community_report_repository.dart';

import '../repositories/mock/mock_geospatial_repositories.dart';
import '../repositories/supabase/supabase_geospatial_repositories.dart';

import 'supabase_provider.dart';

final _mockAuthRepo = MockAuthRepository();
final _mockProfileRepo = MockProfileRepository();
final _mockTrustedContactsRepo = MockTrustedContactsRepository();
final _mockUserPrefsRepo = MockUserPreferencesRepository();
final _mockRouteHistoryRepo = MockRouteHistoryRepository();

final _mockRoadSegmentRepo = MockRoadSegmentRepository();
final _mockSafetyFeatureRepo = MockSafetyFeatureRepository();
final _mockPointOfInterestRepo = MockPointOfInterestRepository();
final _mockHazardRepo = MockHazardRepository();
final _mockCommunityReportRepo = MockCommunityReportRepository();
final _mockNavigationRepo = MockNavigationRepository(_mockHazardRepo, _mockCommunityReportRepo);

/// Provides the active AuthRepository (Supabase or Mock) based on environment.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
  }
  return _mockAuthRepo;
});

/// A provider that streams the authentication state (true if authenticated, false otherwise).
final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseProfileRepository(ref.watch(supabaseClientProvider));
  }
  return _mockProfileRepo;
});

final trustedContactsRepositoryProvider = Provider<TrustedContactsRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseTrustedContactsRepository(ref.watch(supabaseClientProvider));
  }
  return _mockTrustedContactsRepo;
});

final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseUserPreferencesRepository(ref.watch(supabaseClientProvider));
  }
  return _mockUserPrefsRepo;
});

final routeHistoryRepositoryProvider = Provider<RouteHistoryRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseRouteHistoryRepository(ref.watch(supabaseClientProvider));
  }
  return _mockRouteHistoryRepo;
});

// GEOSPATIAL PROVIDERS

final roadSegmentRepositoryProvider = Provider<RoadSegmentRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseRoadSegmentRepository(client: ref.watch(supabaseClientProvider));
  }
  return _mockRoadSegmentRepo;
});

final safetyFeatureRepositoryProvider = Provider<SafetyFeatureRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseSafetyFeatureRepository(client: ref.watch(supabaseClientProvider));
  }
  return _mockSafetyFeatureRepo;
});

final pointOfInterestRepositoryProvider = Provider<PointOfInterestRepository>((ref) {
  if (Env.useSupabase) {
    return SupabasePointOfInterestRepository(client: ref.watch(supabaseClientProvider));
  }
  return _mockPointOfInterestRepo;
});

final hazardRepositoryProvider = Provider<HazardRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseHazardRepository(client: ref.watch(supabaseClientProvider));
  }
  return _mockHazardRepo;
});

final communityReportRepositoryProvider = Provider<CommunityReportRepository>((ref) {
  if (Env.useSupabase) {
    return SupabaseCommunityReportRepository(client: ref.watch(supabaseClientProvider));
  }
  return _mockCommunityReportRepo;
});

final navigationRepositoryProvider = Provider<NavigationRepository>((ref) {
  return _mockNavigationRepo;
});
