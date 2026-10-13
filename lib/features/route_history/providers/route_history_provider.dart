import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/route_history_model.dart';
import '../../../core/providers/repository_providers.dart';

final routeHistoryProvider = StateNotifierProvider<RouteHistoryNotifier, AsyncValue<List<RouteHistory>>>((ref) {
  return RouteHistoryNotifier(ref);
});

class RouteHistoryNotifier extends StateNotifier<AsyncValue<List<RouteHistory>>> {
  final Ref _ref;

  RouteHistoryNotifier(this._ref) : super(const AsyncLoading()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(routeHistoryRepositoryProvider);
      final history = await repo.getRouteHistory('dummy_user_id');
      state = AsyncData(history);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addHistory(RouteHistory entry) async {
    try {
      final repo = _ref.read(routeHistoryRepositoryProvider);
      await repo.addRouteHistory(entry);
      // Refresh the list
      await fetchHistory();
    } catch (e) {
      // Intentionally ignoring error for UI brevity, in a real app show a snackbar
      rethrow;
    }
  }
}
