# NaviHer - Supabase Architecture

## Overview
NaviHer uses Supabase as its primary backend, acting as a direct PostgreSQL database, Authentication provider, and eventually Edge Functions (if needed). The Flutter application connects directly to Supabase.

## Architecture Layers
- **UI Layer**: Riverpod Providers & Flutter Widgets.
- **Repository Layer**: Abstract interfaces (`AuthRepository`, `ProfileRepository`, etc.).
- **Implementation Layer**: Supabase-backed concrete repositories (and Mock fallbacks for dev).
- **Backend**: Supabase Postgres DB & Auth.

## Authentication Flow
1. User enters Email/Password or uses Social Login (future).
2. Flutter App calls `Supabase.instance.client.auth.signInWithPassword`.
3. Supabase issues a JWT.
4. Riverpod `authStateProvider` detects the new session.
5. `goRouterProvider` listens to `authStateProvider` and redirects to `/home`.

## Row Level Security (RLS)
The database enforces strict RLS policies on ALL tables.
The fundamental rule is: **A user can only `SELECT`, `INSERT`, `UPDATE`, or `DELETE` rows where `user_id = auth.uid()`**.
There are no shared tables yet. All data is scoped specifically to the logged-in user.
