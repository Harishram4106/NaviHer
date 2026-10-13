import '../models/route_history_model.dart';

abstract class RouteHistoryRepository {
  Future<List<RouteHistory>> getRouteHistory(String userId);
  Future<void> addRouteHistory(RouteHistory route);
  Future<void> deleteRouteHistory(String routeId);
}
