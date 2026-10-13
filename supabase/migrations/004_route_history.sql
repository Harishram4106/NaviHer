-- Migration: 004_route_history
-- Description: Create route_history table and enforce RLS.

CREATE TABLE route_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  distance_km FLOAT NOT NULL,
  safety_score INTEGER NOT NULL,
  type TEXT NOT NULL, -- e.g., 'naviherSafe', 'fastest'
  safety_factors JSONB,
  polyline JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE route_history ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own route history"
  ON route_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own route history"
  ON route_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own route history"
  ON route_history FOR DELETE
  USING (auth.uid() = user_id);
