# NaviHer - Database Schema & Policies

## Tables

### `profiles`
Stores user profile information.
- `id` (UUID, primary key, references `auth.users`)
- `name` (TEXT)
- `email` (TEXT)
- `avatar_url` (TEXT, optional)

### `trusted_contacts`
Stores a user's trusted emergency contacts.
- `id` (UUID, primary key)
- `user_id` (UUID, references `profiles`)
- `name` (TEXT)
- `phone_number` (TEXT)
- `is_active` (BOOLEAN)

### `user_preferences`
Stores custom settings for a user.
- `id` (UUID, primary key)
- `user_id` (UUID, references `profiles`, UNIQUE)
- `share_location_automatically` (BOOLEAN)
- `preferred_transport_mode` (TEXT)
- `alert_radius_km` (FLOAT)

### `route_history`
Stores previously completed routes.
- `id` (UUID, primary key)
- `user_id` (UUID, references `profiles`)
- `name` (TEXT)
- `duration_minutes` (INTEGER)
- `distance_km` (FLOAT)
- `safety_score` (INTEGER)
- `type` (TEXT)
- `safety_factors` (JSONB)
- `polyline` (JSONB)

## Row Level Security
All tables strictly enforce RLS where operations are restricted to `user_id = auth.uid()`. Cross-user data access is completely prohibited at the database level.
