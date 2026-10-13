-- Migration: 005_postgis_and_road_segments.sql
-- Description: Enables PostGIS, creates road_segments table, indexes, and RLS.

-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create road_segments table
CREATE TABLE road_segments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    external_id TEXT,
    name TEXT,
    geometry GEOMETRY(LineString, 4326) NOT NULL,
    length_meters NUMERIC CHECK (length_meters >= 0),
    estimated_travel_time_seconds INTEGER CHECK (estimated_travel_time_seconds >= 0),
    source TEXT,
    source_id TEXT,
    is_demo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure geometry is valid
ALTER TABLE road_segments ADD CONSTRAINT road_segments_geometry_is_valid CHECK (ST_IsValid(geometry));

-- Create Spatial Index
CREATE INDEX idx_road_segments_geom ON road_segments USING GIST (geometry);

-- Create index on source and source_id
CREATE INDEX idx_road_segments_source ON road_segments(source, source_id);

-- Enable RLS
ALTER TABLE road_segments ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read road segments
CREATE POLICY "Authenticated users can read road segments"
    ON road_segments
    FOR SELECT
    TO authenticated
    USING (true);

-- Trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON road_segments 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
