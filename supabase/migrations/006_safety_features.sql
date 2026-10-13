-- Migration: 006_safety_features.sql
-- Description: Creates safety_features table, CHECK constraints, and RLS.

CREATE TABLE safety_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    road_segment_id UUID REFERENCES road_segments(id) ON DELETE CASCADE,
    lighting_score NUMERIC CHECK (lighting_score >= 0 AND lighting_score <= 100),
    activity_score NUMERIC CHECK (activity_score >= 0 AND activity_score <= 100),
    emergency_access_score NUMERIC CHECK (emergency_access_score >= 0 AND emergency_access_score <= 100),
    open_business_score NUMERIC CHECK (open_business_score >= 0 AND open_business_score <= 100),
    road_quality_score NUMERIC CHECK (road_quality_score >= 0 AND road_quality_score <= 100),
    isolation_score NUMERIC CHECK (isolation_score >= 0 AND isolation_score <= 100),
    hazard_score NUMERIC CHECK (hazard_score >= 0 AND hazard_score <= 100),
    risk_signal_score NUMERIC CHECK (risk_signal_score >= 0 AND risk_signal_score <= 100),
    confidence NUMERIC CHECK (confidence >= 0 AND confidence <= 100),
    freshness_timestamp TIMESTAMPTZ,
    source TEXT,
    source_id TEXT,
    is_demo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for relationship
CREATE INDEX idx_safety_features_road_segment ON safety_features(road_segment_id);

-- Enable RLS
ALTER TABLE safety_features ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read safety features
CREATE POLICY "Authenticated users can read safety features"
    ON safety_features
    FOR SELECT
    TO authenticated
    USING (true);

-- Trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON safety_features 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
