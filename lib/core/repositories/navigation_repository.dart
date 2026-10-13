import '../models/route_model.dart';

/// Abstract navigation repository.
/// Supabase implementation will replace the mock in a later phase.
abstract class NavigationRepository {
  Future<List<RouteModel>> getRoutes({
    required String from,
    required String to,
    required RouteTravelMode mode,
  });

  Future<NavigationSession?> getActiveSession();
}
