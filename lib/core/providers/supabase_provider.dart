import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

/// Provides the global SupabaseClient instance if initialized.
/// Throws an error if Supabase is disabled in Env but requested.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!Env.useSupabase) {
    throw StateError('Supabase is disabled in current environment.');
  }
  return Supabase.instance.client;
});

/// Streams the authentication state from Supabase.
final supabaseAuthStateProvider = StreamProvider<AuthState>((ref) {
  if (!Env.useSupabase) {
    return const Stream.empty();
  }
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});
