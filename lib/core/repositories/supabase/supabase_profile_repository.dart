import 'package:supabase_flutter/supabase_flutter.dart';
import '../../errors/app_exceptions.dart';
import '../../models/user_model.dart';
import '../profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;

  SupabaseProfileRepository(this._client);

  @override
  Future<UserModel> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException('Profile not found.');
      }
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> updateProfile(UserModel profile) async {
    try {
      await _client.from('profiles').update(profile.toJson()).eq('id', profile.id);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }
}
