-- Migration: 007_points_of_interest.sql
-- Description: Creates points_of_interest table, spatial indexes, and RLS.

CREATE TABLE points_of_interest (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    location GEOMETRY(Point, 4326) NOT NULL,
    address TEXT,
    is_open BOOLEAN,
    source TEXT,
    source_id TEXT,
    freshness_timestamp TIMESTAMPTZ,
    is_demo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure geometry is valid
ALTER TABLE points_of_interest ADD CONSTRAINT points_of_interest_geometry_is_valid CHECK (ST_IsValid(location));

-- Spatial index
CREATE INDEX idx_points_of_interest_location ON points_of_interest USING GIST (location);

-- Category index
CREATE INDEX idx_points_of_interest_category ON points_of_interest(category);

-- Enable RLS
ALTER TABLE points_of_interest ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read points of interest
CREATE POLICY "Authenticated users can read POIs"
    ON points_of_interest
    FOR SELECT
    TO authenticated
    USING (true);

-- Trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON points_of_interest 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
