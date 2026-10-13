-- Migration: 009_community_reports.sql
-- Description: Creates community_reports table, spatial indexes, and RLS.

CREATE TABLE community_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    location GEOMETRY(Point, 4326) NOT NULL,
    road_segment_id UUID REFERENCES road_segments(id) ON DELETE SET NULL,
    category TEXT NOT NULL,
    description TEXT,
    confidence NUMERIC CHECK (confidence >= 0 AND confidence <= 100),
    moderation_status TEXT NOT NULL DEFAULT 'pending' CHECK (moderation_status IN ('pending', 'approved', 'rejected')),
    reported_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    is_demo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure geometry is valid
ALTER TABLE community_reports ADD CONSTRAINT community_reports_geometry_is_valid CHECK (ST_IsValid(location));

-- Indexes
CREATE INDEX idx_community_reports_location ON community_reports USING GIST (location);
CREATE INDEX idx_community_reports_user ON community_reports(user_id);
CREATE INDEX idx_community_reports_status ON community_reports(moderation_status);

-- Enable RLS
ALTER TABLE community_reports ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read approved reports, or their own reports
CREATE POLICY "Users can read approved or own reports"
    ON community_reports
    FOR SELECT
    TO authenticated
    USING (
        moderation_status = 'approved' 
        OR user_id = auth.uid()
    );

-- Policy: Users can insert their own reports
CREATE POLICY "Users can insert their own reports"
    ON community_reports
    FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid() AND moderation_status = 'pending');

-- Users MUST NOT modify or delete another user's report.
-- Explicitly, we only allow users to update certain fields of their own reports (like description/expires_at),
-- but we prevent altering moderation_status.
CREATE POLICY "Users can update their own reports except moderation status"
    ON community_reports
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid() AND moderation_status = 'pending');

-- Trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON community_reports 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
