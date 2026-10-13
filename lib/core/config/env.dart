class Env {
  // Use `flutter run --dart-define=SUPABASE_URL=...` or define in build config
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'placeholder_anon_key',
  );

  // Feature flag to switch between Supabase and Mock repositories
  // Defaults to false for development until a backend is fully connected.
  static const useSupabase = bool.fromEnvironment(
    'USE_SUPABASE',
    defaultValue: false,
  );
}
