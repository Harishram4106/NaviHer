import 'package:supabase_flutter/supabase_flutter.dart';
import '../../errors/app_exceptions.dart';
import '../../models/route_history_model.dart';
import '../route_history_repository.dart';

class SupabaseRouteHistoryRepository implements RouteHistoryRepository {
  final SupabaseClient _client;

  SupabaseRouteHistoryRepository(this._client);

  @override
  Future<List<RouteHistory>> getRouteHistory(String userId) async {
    try {
      final response = await _client
          .from('route_history')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
          
      return (response as List).map((json) => RouteHistory.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> addRouteHistory(RouteHistory route) async {
    try {
      await _client
          .from('route_history')
          .insert(route.toJson()..remove('id')); // Let DB generate ID
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> deleteRouteHistory(String routeId) async {
    try {
      await _client.from('route_history').delete().eq('id', routeId);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }
}
