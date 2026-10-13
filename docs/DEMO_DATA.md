# Demo Data Implementation

## Purpose
To facilitate testing, UI development, and early-stage validation, NaviHer AI explicitly isolates demonstration data from real user data.

## Implementation Mechanism
All geospatial tables (`road_segments`, `safety_features`, `points_of_interest`, `hazards`, `community_reports`) include an `is_demo` boolean flag. 
- `is_demo` defaults to `false`.
- The database migration `011-demo-data.sql` inserts sample records directly into the Supabase instance, explicitly setting `is_demo = true`.

## Filtering Strategy
Currently, repository reads do not strictly filter out demo data, as the application is in an early prototype phase. In production, policies and UI filters will explicitly hide `is_demo = true` records unless a user is in a dedicated "demo mode".

## Sample Scenarios
The demo data migration provisions data primarily in a mock urban grid (e.g., San Francisco test coordinates):
- **Safe Route Path:** Brightly lit road segments with cameras and nearby transit stops.
- **Unsafe Path:** Poorly lit segments with reported hazards and recent community incident reports.
- **POIs:** Several "Safe Space" stores and "Transit Stations".

This guarantees that developers and CI environments have immediate access to varied datasets for routing visualizations.
