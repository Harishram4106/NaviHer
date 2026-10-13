-- Migration: 010_spatial_functions.sql
-- Description: RPCs for spatial queries that return GeoJSON for easy Flutter consumption.

-- 1. Find nearby Points of Interest
CREATE OR REPLACE FUNCTION get_nearby_pois(p_lat double precision, p_lon double precision, p_radius_meters double precision)
RETURNS TABLE (
    id UUID,
    name TEXT,
    category TEXT,
    geometry jsonb,
    address TEXT,
    is_open BOOLEAN,
    is_demo BOOLEAN,
    source TEXT,
    source_id TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id, p.name, p.category, 
        ST_AsGeoJSON(p.location)::jsonb as geometry,
        p.address, p.is_open, p.is_demo, p.source, p.source_id
    FROM points_of_interest p
    WHERE ST_DWithin(
        p.location::geography,
        ST_SetSRID(ST_MakePoint(p_lon, p_lat), 4326)::geography,
        p_radius_meters
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Find nearby Road Segments
CREATE OR REPLACE FUNCTION get_nearby_road_segments(p_lat double precision, p_lon double precision, p_radius_meters double precision)
RETURNS TABLE (
    id UUID,
    name TEXT,
    geometry jsonb,
    length_meters NUMERIC,
    estimated_travel_time_seconds INTEGER,
    is_demo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id, r.name, 
        ST_AsGeoJSON(r.geometry)::jsonb as geometry,
        r.length_meters, r.estimated_travel_time_seconds, r.is_demo
    FROM road_segments r
    WHERE ST_DWithin(
        r.geometry::geography,
        ST_SetSRID(ST_MakePoint(p_lon, p_lat), 4326)::geography,
        p_radius_meters
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Find hazards near a road segment (by segment ID)
CREATE OR REPLACE FUNCTION get_hazards_for_segment(p_segment_id UUID)
RETURNS TABLE (
    id UUID,
    category TEXT,
    severity NUMERIC,
    confidence NUMERIC,
    description TEXT,
    status TEXT,
    geometry jsonb,
    reported_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    is_demo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        h.id, h.category, h.severity, h.confidence, h.description, h.status,
        ST_AsGeoJSON(h.location)::jsonb as geometry,
        h.reported_at, h.expires_at, h.is_demo
    FROM hazards h
    WHERE h.road_segment_id = p_segment_id
      AND h.status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Find community reports near a road segment (by segment ID)
CREATE OR REPLACE FUNCTION get_reports_for_segment(p_segment_id UUID)
RETURNS TABLE (
    id UUID,
    category TEXT,
    description TEXT,
    confidence NUMERIC,
    moderation_status TEXT,
    geometry jsonb,
    reported_at TIMESTAMPTZ,
    is_demo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id, c.category, c.description, c.confidence, c.moderation_status,
        ST_AsGeoJSON(c.location)::jsonb as geometry,
        c.reported_at, c.is_demo
    FROM community_reports c
    WHERE c.road_segment_id = p_segment_id
      AND c.moderation_status = 'approved';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Find safety features for a road segment
CREATE OR REPLACE FUNCTION get_safety_features(p_segment_id UUID)
RETURNS SETOF safety_features AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM safety_features
    WHERE road_segment_id = p_segment_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
