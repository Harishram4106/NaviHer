import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<bool> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      return event.session != null;
    });
  }

  @override
  String? get currentUserId => _client.auth.currentUser?.id;
}
