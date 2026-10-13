# Geospatial Database

## Schema Design
The geospatial layer relies heavily on the `postgis` extension. We explicitly manage geometries using SRID 4326 (WGS 84).

### Core Tables
1. **`road_segments`**: Defines the physical pathways (streets, sidewalks) with `geometry(LineString, 4326)`. Includes properties for lighting, foot traffic, and road type.
2. **`safety_features`**: Static infrastructural points (cameras, streetlights, help points) stored as `geometry(Point, 4326)`.
3. **`points_of_interest`**: Safe locations (transit stations, safe spaces) stored as `geometry(Point, 4326)`.
4. **`hazards`**: Temporal or permanent physical risks (poor lighting, construction, high crime area) stored as `geometry(Geometry, 4326)` to support both Points and Polygons.
5. **`community_reports`**: User-submitted crowdsourced incidents stored as `geometry(Point, 4326)`.

## Spatial Indexes
Every table has a GiST (Generalized Search Tree) index on its `geom` column to ensure that spatial queries (`ST_DWithin`, `ST_Intersects`) are blazingly fast.

## Row-Level Security (RLS)
- Baseline spatial data (`road_segments`, `safety_features`, `pois`, `hazards`) is publicly readable (`SELECT` for authenticated and anonymous users if permitted) but strictly restricted for mutations (only admin/service roles can insert/update).
- `community_reports` allows authenticated users to insert rows where `user_id = auth.uid()`. Read access is currently restricted to approved/pending reports for safety validation.

## Custom RPCs (Serialization)
Due to issues handling WKB in the Dart `supabase_flutter` client, we leverage stored procedures:
- `get_nearby_pois`: Takes a point and radius, returns POIs as GeoJSON points.
- `get_reports_for_segment`: Takes a road segment ID, uses an intersection query with a small buffer, and returns reports mapped to GeoJSON.
- `insert_community_report`: Safely wraps insertion with a geometry constructor (`ST_SetSRID(ST_MakePoint(lon, lat), 4326)`).
