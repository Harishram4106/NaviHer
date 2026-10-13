# NaviHer - Environment Strategy

NaviHer uses Dart defines for environment variables during build time. This ensures that no secrets (e.g., API keys, database passwords) are ever committed to the repository in plaintext.

## Required Environment Variables

When running or building the app, you MUST provide the following dart-defines:

- `SUPABASE_URL`: The URL of your Supabase instance.
- `SUPABASE_ANON_KEY`: The anonymous public API key for your Supabase instance.
- `USE_SUPABASE`: Set to `true` to use real Supabase repositories, or `false` (default) to use Mock repositories.

## How to Run

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=USE_SUPABASE=true
```

## Security Rules
- NEVER commit `.env` files.
- NEVER hardcode keys inside the `lib/` directory.
- Use `String.fromEnvironment()` to safely read keys at runtime.
