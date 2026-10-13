import 'package:supabase_flutter/supabase_flutter.dart';
import '../../errors/app_exceptions.dart';
import '../../models/user_preference_model.dart';
import '../user_preferences_repository.dart';

class SupabaseUserPreferencesRepository implements UserPreferencesRepository {
  final SupabaseClient _client;

  SupabaseUserPreferencesRepository(this._client);

  @override
  Future<UserPreference> getPreferences(String userId) async {
    try {
      final response = await _client
          .from('user_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // If not found, return default preferences
        return UserPreference(id: '', userId: userId);
      }
      
      return UserPreference.fromJson(response);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> updatePreferences(UserPreference preferences) async {
    try {
      await _client
          .from('user_preferences')
          .upsert(preferences.toJson()..remove('id')) // upsert based on user_id unique constraint
          .eq('user_id', preferences.userId);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }
}
