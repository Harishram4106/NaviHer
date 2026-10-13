import 'package:flutter_test/flutter_test.dart';
import 'package:naviher_ai/core/models/geospatial/coordinate_utils.dart';
import 'package:naviher_ai/core/models/geospatial/road_segment.dart';
import 'package:naviher_ai/core/models/geospatial/safety_feature.dart';

void main() {
  group('Geospatial Domain Models Validation', () {
    test('Coordinate.fromGeoJsonArray parses correctly', () {
      final coord = Coordinate.fromGeoJsonArray([-122.4031, 37.7879]);
      expect(coord.longitude, -122.4031);
      expect(coord.latitude, 37.7879);
    });

    test('Coordinate.fromGeoJsonArray throws on invalid range', () {
      expect(() => Coordinate.fromGeoJsonArray([-200.0, 37.7879]), throwsFormatException);
      expect(() => Coordinate.fromGeoJsonArray([-122.4031, 100.0]), throwsFormatException);
    });

    test('RoadSegment constraints', () {
      expect(
        () => RoadSegment(
          id: '1',
          geometry: [Coordinate(latitude: 0, longitude: 0)],
          lengthMeters: -10, // Invalid
        ),
        throwsArgumentError,
      );
    });

    test('SafetyFeature constraints', () {
      expect(
        () => SafetyFeature(
          id: '1',
          roadSegmentId: '1',
          lightingScore: 105, // Invalid > 100
        ),
        throwsArgumentError,
      );

      expect(
        () => SafetyFeature(
          id: '2',
          roadSegmentId: '1',
          confidence: -5, // Invalid < 0
        ),
        throwsArgumentError,
      );
    });

    test('GeoJSON Serialization for RoadSegment', () {
      final json = {
        'id': 'seg1',
        'geometry': {
          'type': 'LineString',
          'coordinates': [
            [-122.4, 37.7],
            [-122.3, 37.8],
          ]
        },
        'length_meters': 150.5,
        'estimated_travel_time_seconds': 30,
        'is_demo': true,
      };

      final segment = RoadSegment.fromJson(json);
      expect(segment.id, 'seg1');
      expect(segment.geometry.length, 2);
      expect(segment.geometry[0].longitude, -122.4);
      expect(segment.lengthMeters, 150.5);
      expect(segment.isDemo, true);

      final outJson = segment.toJson();
      expect(outJson['geometry']['type'], 'LineString');
    });
  });
}
