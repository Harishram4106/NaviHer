-- Migration: 011_demo_data.sql
-- Description: Inserts synthetic deterministic geospatial demo data for NaviHer AI.

-- All demo data should have is_demo = true and source = 'demo' where applicable.

-- We use a localized area (San Francisco Downtown roughly)
-- Coordinates: Longitude, Latitude (X, Y)

DO $$ 
DECLARE
    rs1_id UUID;
    rs2_id UUID;
    rs3_id UUID;
BEGIN

    -- 1. Road Segments
    -- Segment 1: Market St (approx)
    INSERT INTO road_segments (name, geometry, length_meters, estimated_travel_time_seconds, source, is_demo)
    VALUES (
        'Market St (Demo)',
        ST_GeomFromText('LINESTRING(-122.4031 37.7879, -122.4005 37.7898)', 4326),
        350, 45, 'demo', true
    ) RETURNING id INTO rs1_id;

    -- Segment 2: 3rd St
    INSERT INTO road_segments (name, geometry, length_meters, estimated_travel_time_seconds, source, is_demo)
    VALUES (
        '3rd St (Demo)',
        ST_GeomFromText('LINESTRING(-122.4005 37.7898, -122.3989 37.7872)', 4326),
        300, 35, 'demo', true
    ) RETURNING id INTO rs2_id;

    -- Segment 3: Mission St
    INSERT INTO road_segments (name, geometry, length_meters, estimated_travel_time_seconds, source, is_demo)
    VALUES (
        'Mission St (Demo)',
        ST_GeomFromText('LINESTRING(-122.4031 37.7879, -122.3989 37.7872)', 4326),
        400, 50, 'demo', true
    ) RETURNING id INTO rs3_id;


    -- 2. Safety Features (for each segment)
    INSERT INTO safety_features (road_segment_id, lighting_score, activity_score, emergency_access_score, open_business_score, road_quality_score, isolation_score, hazard_score, risk_signal_score, confidence, source, is_demo)
    VALUES 
        (rs1_id, 85, 90, 80, 95, 75, 10, 5, 10, 92, 'demo', true),
        (rs2_id, 60, 50, 75, 40, 85, 30, 20, 25, 88, 'demo', true),
        (rs3_id, 95, 85, 90, 80, 80, 5, 0, 5, 95, 'demo', true);


    -- 3. Points of Interest
    INSERT INTO points_of_interest (name, category, location, address, is_open, source, is_demo)
    VALUES 
        ('SF General (Demo)', 'hospital', ST_SetSRID(ST_MakePoint(-122.4045, 37.7890), 4326), '100 Demo Way', true, 'demo', true),
        ('Central Police Station (Demo)', 'police', ST_SetSRID(ST_MakePoint(-122.4080, 37.7920), 4326), '200 Justice Ln', true, 'demo', true),
        ('24/7 Pharmacy (Demo)', 'pharmacy', ST_SetSRID(ST_MakePoint(-122.4000, 37.7885), 4326), '300 Health Blvd', true, 'demo', true),
        ('Late Night Cafe (Demo)', 'business', ST_SetSRID(ST_MakePoint(-122.3995, 37.7892), 4326), '400 Bean St', true, 'demo', true),
        ('Transit Hub (Demo)', 'transport', ST_SetSRID(ST_MakePoint(-122.4010, 37.7905), 4326), '500 Metro Pl', true, 'demo', true);


    -- 4. Hazards
    INSERT INTO hazards (road_segment_id, location, category, severity, confidence, description, status, source, is_demo)
    VALUES 
        (rs2_id, ST_SetSRID(ST_MakePoint(-122.3995, 37.7880), 4326), 'flooding', 75, 90, 'Deep puddle covering right lane', 'active', 'demo', true),
        (rs1_id, ST_SetSRID(ST_MakePoint(-122.4020, 37.7885), 4326), 'lighting_failure', 40, 85, 'Streetlight flickers/out', 'active', 'demo', true),
        (rs3_id, ST_SetSRID(ST_MakePoint(-122.4010, 37.7875), 4326), 'construction', 20, 95, 'Minor sidewalk repair', 'resolved', 'demo', true);


    -- 5. Community Reports (assuming no explicit user_id for demo data, they are anonymous)
    INSERT INTO community_reports (road_segment_id, location, category, description, confidence, moderation_status, is_demo)
    VALUES
        (rs1_id, ST_SetSRID(ST_MakePoint(-122.4025, 37.7882), 4326), 'safe_area', 'Well lit, many people walking.', 80, 'approved', true),
        (rs2_id, ST_SetSRID(ST_MakePoint(-122.3992, 37.7878), 4326), 'suspicious_activity', 'A group of people yelling near the alley.', 65, 'approved', true),
        (rs3_id, ST_SetSRID(ST_MakePoint(-122.4005, 37.7875), 4326), 'open_business', 'Food truck still open at 1am.', 90, 'approved', true),
        (rs2_id, ST_SetSRID(ST_MakePoint(-122.3997, 37.7885), 4326), 'poor_lighting', 'Very dark under the scaffolding.', 70, 'pending', true);

END $$;
