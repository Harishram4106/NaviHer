# Geospatial Architecture

## Overview
NaviHer AI uses PostGIS within Supabase for all geospatial data management. This document outlines the spatial data architecture and serialization strategy connecting the Flutter frontend to the Postgres backend.

## Flutter Domain Models
All spatial models reside in `lib/core/models/geospatial/`. 
The core type is `Coordinate(latitude, longitude)`, representing a WGS84 point.

Models include:
- `CoordinateUtils`: Core coordinate management and GeoJSON mapping
- `RoadSegment`: Represents a road path (LineString)
- `SafetyFeature`: Infrastructure features like streetlights or cameras (Point)
- `PointOfInterest`: Notable locations like transit stops (Point)
- `Hazard`: Environmental or physical dangers (Point or Polygon)
- `CommunityReport`: User-submitted safety incidents (Point)

## Serialization Strategy
Standard PostgREST API calls return spatial data as WKB (Well-Known Binary) hex strings, which are cumbersome to parse in Dart without heavy dependencies. 
To guarantee cross-platform compatibility and avoid native parsing issues, NaviHer AI explicitly uses **GeoJSON**.

- **Database Reads:** We rely on PostgreSQL Custom RPCs (Stored Procedures) to execute `ST_AsGeoJSON(geom)::jsonb` so that the client receives easily parseable JSON objects.
- **Database Writes:** We pass `[longitude, latitude]` arrays directly, or insert coordinates which PostGIS casts to geometry.
- **Dart Layer:** Models consume `Map<String, dynamic>` standard GeoJSON representations directly, simplifying parsing.

## Repository Pattern
- **Interfaces:** `lib/core/repositories/geospatial/` holds abstract contracts.
- **Mocks:** `MockGeospatialRepository` returns deterministic dummy data for testing UI logic.
- **Supabase:** `SupabaseGeospatialRepository` calls the specific RPC functions like `get_nearby_pois`, `get_reports_for_segment`, etc.

## Spatial Queries
We use the `ST_DWithin` function combined with geography casting (or UTM projection approximations) to execute efficient radius and proximity searches directly at the database layer.

## Future Phases
Future routing phases will implement pgRouting and Dijkstra/A* on the road segment topology we've established.
