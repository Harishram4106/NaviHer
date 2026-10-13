import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/geospatial/road_segment.dart';
import '../../models/geospatial/safety_feature.dart';
import '../../models/geospatial/point_of_interest.dart';
import '../../models/geospatial/hazard.dart';
import '../../models/geospatial/community_report.dart';

import '../geospatial/road_segment_repository.dart';
import '../geospatial/safety_feature_repository.dart';
import '../geospatial/point_of_interest_repository.dart';
import '../geospatial/hazard_repository.dart';
import '../geospatial/community_report_repository.dart';

class SupabaseRoadSegmentRepository implements RoadSegmentRepository {
  final SupabaseClient client;
  SupabaseRoadSegmentRepository({required this.client});

  @override
  Future<List<RoadSegment>> getNearbyRoadSegments(double lat, double lon, double radiusMeters) async {
    final response = await client.rpc('get_nearby_road_segments', params: {
      'p_lat': lat,
      'p_lon': lon,
      'p_radius_meters': radiusMeters,
    });
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => RoadSegment.fromJson(json as Map<String, dynamic>)).toList();
  }
}

class SupabaseSafetyFeatureRepository implements SafetyFeatureRepository {
  final SupabaseClient client;
  SupabaseSafetyFeatureRepository({required this.client});

  @override
  Future<List<SafetyFeature>> getForRoadSegment(String roadSegmentId) async {
    final response = await client.rpc('get_safety_features', params: {
      'p_segment_id': roadSegmentId,
    });
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => SafetyFeature.fromJson(json as Map<String, dynamic>)).toList();
  }
}

class SupabasePointOfInterestRepository implements PointOfInterestRepository {
  final SupabaseClient client;
  SupabasePointOfInterestRepository({required this.client});

  @override
  Future<List<PointOfInterest>> getNearbyPointsOfInterest(double lat, double lon, double radiusMeters) async {
    final response = await client.rpc('get_nearby_pois', params: {
      'p_lat': lat,
      'p_lon': lon,
      'p_radius_meters': radiusMeters,
    });
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => PointOfInterest.fromJson(json as Map<String, dynamic>)).toList();
  }
}

class SupabaseHazardRepository implements HazardRepository {
  final SupabaseClient client;
  SupabaseHazardRepository({required this.client});

  @override
  Future<List<Hazard>> getHazardsForSegment(String roadSegmentId) async {
    final response = await client.rpc('get_hazards_for_segment', params: {
      'p_segment_id': roadSegmentId,
    });
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => Hazard.fromJson(json as Map<String, dynamic>)).toList();
  }
}

class SupabaseCommunityReportRepository implements CommunityReportRepository {
  final SupabaseClient client;
  SupabaseCommunityReportRepository({required this.client});

  @override
  Future<List<CommunityReport>> getReportsForSegment(String roadSegmentId) async {
    final response = await client.rpc('get_reports_for_segment', params: {
      'p_segment_id': roadSegmentId,
    });
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => CommunityReport.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<CommunityReport> createReport(CommunityReport report) async {
    final data = report.toJson();
    // Use ST_GeomFromGeoJSON for the insert location, wait, Supabase doesn't let us easily send JSON to a GEOMETRY column from a standard insert().
    // We would need to send it as a WKT string, or use an RPC. 
    // Since we are inserting directly into a geometry column, we'll format it as EWKT or WKT.
    // 'SRID=4326;POINT(-122.4031 37.7879)'
    data['location'] = 'SRID=4326;POINT(${report.location.longitude} ${report.location.latitude})';
    data.remove('geometry'); // Remove the JSON geometry property used for serialization
    data.remove('id'); // Let DB generate ID
    data.remove('created_at');
    data.remove('updated_at');

    final response = await client.from('community_reports').insert(data).select().single();
    // Note: The select() will return location as WKB/HEX unless we cast it, 
    // but we can just return the input report with the new ID for simplicity,
    // or re-fetch it using an RPC if we need the GeoJSON format.
    // For now, we will just parse the simple fields back or just return the object we passed in.
    
    // To be perfectly robust without dealing with WKB, we can just return the local object with the new ID:
    return CommunityReport(
      id: response['id'] as String,
      userId: response['user_id'] as String?,
      location: report.location,
      roadSegmentId: report.roadSegmentId,
      category: report.category,
      description: report.description,
      confidence: report.confidence,
      moderationStatus: report.moderationStatus,
      reportedAt: DateTime.parse(response['reported_at'] as String),
      expiresAt: report.expiresAt,
      isDemo: report.isDemo,
      createdAt: response['created_at'] != null ? DateTime.parse(response['created_at'] as String) : null,
      updatedAt: response['updated_at'] != null ? DateTime.parse(response['updated_at'] as String) : null,
    );
  }
}
