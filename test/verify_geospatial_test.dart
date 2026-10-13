// ignore_for_file: avoid_print
// LIVE BACKEND TEST — requires TEST_EMAIL_A, TEST_PASSWORD, and a connected
// Supabase project with geospatial seed data in the .env file.
// Run explicitly with: flutter test --tags live
// Will be SKIPPED in the standard: flutter test
@Tags(['live'])
library;

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:naviher_ai/core/models/geospatial/coordinate_utils.dart';
import 'package:naviher_ai/core/models/geospatial/hazard.dart';
import 'package:naviher_ai/core/models/geospatial/community_report.dart';

import 'package:naviher_ai/core/repositories/supabase/supabase_geospatial_repositories.dart';

void main() {
  // Determine skip reason before group runs.
  final skipReason = (Platform.environment['TEST_EMAIL_A'] ?? '').isEmpty
      ? 'BLOCKED: Live Supabase credentials (TEST_EMAIL_A, TEST_PASSWORD) not available. '
        'Provide them as environment variables to run.'
      : null;

  group('Supabase Geospatial Verification Gate', skip: skipReason, () {
    late SupabaseClient client;
    
    // SF Downtown coordinates for Demo Data queries
    const sfLat = 37.7885;
    const sfLon = -122.4010;
    const sfRadius = 1000.0; // 1km

    setUpAll(() async {
      final supabaseUrl = Platform.environment['SUPABASE_URL'] ?? const String.fromEnvironment('SUPABASE_URL');
      final supabaseAnonKey = Platform.environment['SUPABASE_ANON_KEY'] ?? const String.fromEnvironment('SUPABASE_ANON_KEY');
      
      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        fail('Missing Supabase URL or Anon Key in environment variables');
      }

      client = SupabaseClient(supabaseUrl, supabaseAnonKey);

      final emailA = Platform.environment['TEST_EMAIL_A'] ?? const String.fromEnvironment('TEST_EMAIL_A');
      final password = Platform.environment['TEST_PASSWORD'] ?? const String.fromEnvironment('TEST_PASSWORD');
      
      if (emailA.isEmpty || password.isEmpty) {
        markTestSkipped('BLOCKED: TEST_EMAIL_A or TEST_PASSWORD missing in .env');
        return;
      }

      try {
        await client.auth.signInWithPassword(email: emailA, password: password);
        print('Logged in as Test User A for Geospatial Verification.');
      } catch (e) {
        fail('Failed to login for verification: $e');
      }
    });

    test('Verify PostGIS and Road Segments Table', () async {
      // Direct table query should succeed if table exists and RLS allows
      final response = await client.from('road_segments').select().limit(1);
      expect(response, isA<List>());
      print('PostGIS / Road Segments verification passed.');
    });

    test('Verify PointOfInterest RPC (get_nearby_pois)', () async {
      final repo = SupabasePointOfInterestRepository(client: client);
      final pois = await repo.getNearbyPointsOfInterest(sfLat, sfLon, sfRadius);
      
      expect(pois, isNotNull);
      print('Found ${pois.length} POIs near SF demo area.');
      if (pois.isNotEmpty) {
        expect(pois.first.isDemo, true, reason: 'Expected demo data POIs');
        expect(pois.first.location.latitude, isNotNull);
      }
    });

    test('Verify RoadSegment RPC (get_nearby_road_segments)', () async {
      final repo = SupabaseRoadSegmentRepository(client: client);
      final segments = await repo.getNearbyRoadSegments(sfLat, sfLon, sfRadius);
      
      expect(segments, isNotNull);
      print('Found ${segments.length} Road Segments near SF demo area.');
      if (segments.isNotEmpty) {
        expect(segments.first.isDemo, true);
        expect(segments.first.geometry.isNotEmpty, true);
      }
    });

    test('Verify Hazards RPC (get_hazards_for_segment)', () async {
      final segmentRepo = SupabaseRoadSegmentRepository(client: client);
      final segments = await segmentRepo.getNearbyRoadSegments(sfLat, sfLon, sfRadius);
      
      if (segments.isNotEmpty) {
        final hazardRepo = SupabaseHazardRepository(client: client);
        final hazards = await hazardRepo.getHazardsForSegment(segments.first.id);
        print('Found ${hazards.length} hazards for segment ${segments.first.id}');
        if (hazards.isNotEmpty) {
          expect(hazards.first.status, HazardStatus.active);
        }
      } else {
        print('Warning: No segments found to test hazards.');
      }
    });

    test('Verify SafetyFeatures RPC (get_safety_features)', () async {
      final segmentRepo = SupabaseRoadSegmentRepository(client: client);
      final segments = await segmentRepo.getNearbyRoadSegments(sfLat, sfLon, sfRadius);
      
      if (segments.isNotEmpty) {
        final safetyRepo = SupabaseSafetyFeatureRepository(client: client);
        final features = await safetyRepo.getForRoadSegment(segments.first.id);
        print('Found ${features.length} safety features for segment ${segments.first.id}');
        if (features.isNotEmpty) {
          expect(features.first.isDemo, true);
        }
      }
    });

    test('Verify Community Reports Creation and Retrieval', () async {
      final segmentRepo = SupabaseRoadSegmentRepository(client: client);
      final segments = await segmentRepo.getNearbyRoadSegments(sfLat, sfLon, sfRadius);
      
      final reportRepo = SupabaseCommunityReportRepository(client: client);
      
      if (segments.isNotEmpty) {
        // Test Retrieval
        final reports = await reportRepo.getReportsForSegment(segments.first.id);
        print('Found ${reports.length} approved reports for segment ${segments.first.id}');
        
        // Test Creation
        final newReport = CommunityReport(
          id: '',
          location: Coordinate(latitude: sfLat, longitude: sfLon),
          category: 'other',
          description: 'Test Verification Report',
          confidence: 50.0,
          reportedAt: DateTime.now(),
        );

        final created = await reportRepo.createReport(newReport);
        expect(created.id, isNotEmpty);
        expect(created.moderationStatus, ModerationStatus.pending);
        print('Successfully created a test community report with ID: ${created.id}');
      }
    });
  });
}
