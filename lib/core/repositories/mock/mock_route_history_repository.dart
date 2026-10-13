import 'package:uuid/uuid.dart';
import '../../models/route_history_model.dart';
import '../route_history_repository.dart';

class MockRouteHistoryRepository implements RouteHistoryRepository {
  final List<RouteHistory> _history = [];

  @override
  Future<List<RouteHistory>> getRouteHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _history.where((r) => r.userId == userId).toList();
  }

  @override
  Future<void> addRouteHistory(RouteHistory route) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _history.add(RouteHistory(
      id: const Uuid().v4(),
      userId: route.userId,
      name: route.name,
      durationMinutes: route.durationMinutes,
      distanceKm: route.distanceKm,
      safetyScore: route.safetyScore,
      type: route.type,
      safetyFactors: route.safetyFactors,
      polyline: route.polyline,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> deleteRouteHistory(String routeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _history.removeWhere((r) => r.id == routeId);
  }
}
