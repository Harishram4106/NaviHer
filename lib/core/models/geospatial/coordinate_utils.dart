class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  /// Factory to parse from GeoJSON Point coordinates array: [longitude, latitude]
  factory Coordinate.fromGeoJsonArray(List<dynamic> coords) {
    if (coords.length < 2) {
      throw const FormatException('Invalid GeoJSON coordinate array');
    }
    // GeoJSON uses [longitude, latitude]
    final lon = (coords[0] as num).toDouble();
    final lat = (coords[1] as num).toDouble();
    
    if (lat < -90 || lat > 90) throw FormatException('Invalid latitude: $lat');
    if (lon < -180 || lon > 180) throw FormatException('Invalid longitude: $lon');
    
    return Coordinate(latitude: lat, longitude: lon);
  }

  /// Parses from a full GeoJSON object, expecting type "Point"
  factory Coordinate.fromGeoJson(Map<String, dynamic> json) {
    if (json['type'] != 'Point') {
      throw FormatException('Expected GeoJSON Point, got ${json['type']}');
    }
    final coords = json['coordinates'] as List<dynamic>;
    return Coordinate.fromGeoJsonArray(coords);
  }

  Map<String, dynamic> toGeoJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }

  @override
  String toString() => 'Coordinate(lat: $latitude, lon: $longitude)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

class CoordinateUtils {
  /// Parses a GeoJSON LineString into a `List<Coordinate>`
  static List<Coordinate> parseLineString(Map<String, dynamic> json) {
    if (json['type'] != 'LineString') {
      throw FormatException('Expected GeoJSON LineString, got ${json['type']}');
    }
    final coords = json['coordinates'] as List<dynamic>;
    return coords.map((c) => Coordinate.fromGeoJsonArray(c as List<dynamic>)).toList();
  }

  /// Converts a `List<Coordinate>` into a GeoJSON LineString
  static Map<String, dynamic> toLineString(List<Coordinate> coordinates) {
    return {
      'type': 'LineString',
      'coordinates': coordinates.map((c) => [c.longitude, c.latitude]).toList(),
    };
  }
}
