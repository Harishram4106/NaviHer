-- Migration: 008_hazards.sql
-- Description: Creates hazards table, spatial indexes, and RLS.

CREATE TABLE hazards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location GEOMETRY(Point, 4326) NOT NULL,
    road_segment_id UUID REFERENCES road_segments(id) ON DELETE SET NULL,
    category TEXT NOT NULL,
    severity NUMERIC CHECK (severity >= 0 AND severity <= 100),
    confidence NUMERIC CHECK (confidence >= 0 AND confidence <= 100),
    description TEXT,
    source TEXT,
    source_id TEXT,
    reported_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (status IN ('active', 'resolved', 'expired')),
    is_demo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure geometry is valid
ALTER TABLE hazards ADD CONSTRAINT hazards_geometry_is_valid CHECK (ST_IsValid(location));

-- Indexes
CREATE INDEX idx_hazards_location ON hazards USING GIST (location);
CREATE INDEX idx_hazards_road_segment ON hazards(road_segment_id);
CREATE INDEX idx_hazards_status ON hazards(status);
CREATE INDEX idx_hazards_expires_at ON hazards(expires_at);

-- Enable RLS
ALTER TABLE hazards ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read active/public records
CREATE POLICY "Authenticated users can read active hazards"
    ON hazards
    FOR SELECT
    TO authenticated
    USING (status = 'active');

-- Trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON hazards 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
