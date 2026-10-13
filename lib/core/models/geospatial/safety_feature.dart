class SafetyFeature {
  final String id;
  final String roadSegmentId;
  final double? lightingScore;
  final double? activityScore;
  final double? emergencyAccessScore;
  final double? openBusinessScore;
  final double? roadQualityScore;
  final double? isolationScore;
  final double? hazardScore;
  final double? riskSignalScore;
  final double? confidence;
  final DateTime? freshnessTimestamp;
  final String? source;
  final String? sourceId;
  final bool isDemo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SafetyFeature({
    required this.id,
    required this.roadSegmentId,
    this.lightingScore,
    this.activityScore,
    this.emergencyAccessScore,
    this.openBusinessScore,
    this.roadQualityScore,
    this.isolationScore,
    this.hazardScore,
    this.riskSignalScore,
    this.confidence,
    this.freshnessTimestamp,
    this.source,
    this.sourceId,
    this.isDemo = false,
    this.createdAt,
    this.updatedAt,
  }) {
    _validateScore(lightingScore, 'lightingScore');
    _validateScore(activityScore, 'activityScore');
    _validateScore(emergencyAccessScore, 'emergencyAccessScore');
    _validateScore(openBusinessScore, 'openBusinessScore');
    _validateScore(roadQualityScore, 'roadQualityScore');
    _validateScore(isolationScore, 'isolationScore');
    _validateScore(hazardScore, 'hazardScore');
    _validateScore(riskSignalScore, 'riskSignalScore');
    _validateScore(confidence, 'confidence');
  }

  void _validateScore(double? score, String name) {
    if (score != null && (score < 0 || score > 100)) {
      throw ArgumentError('$name must be between 0 and 100, got $score');
    }
  }

  factory SafetyFeature.fromJson(Map<String, dynamic> json) {
    return SafetyFeature(
      id: json['id'] as String,
      roadSegmentId: json['road_segment_id'] as String,
      lightingScore: (json['lighting_score'] as num?)?.toDouble(),
      activityScore: (json['activity_score'] as num?)?.toDouble(),
      emergencyAccessScore: (json['emergency_access_score'] as num?)?.toDouble(),
      openBusinessScore: (json['open_business_score'] as num?)?.toDouble(),
      roadQualityScore: (json['road_quality_score'] as num?)?.toDouble(),
      isolationScore: (json['isolation_score'] as num?)?.toDouble(),
      hazardScore: (json['hazard_score'] as num?)?.toDouble(),
      riskSignalScore: (json['risk_signal_score'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      freshnessTimestamp: json['freshness_timestamp'] != null ? DateTime.parse(json['freshness_timestamp']) : null,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      isDemo: json['is_demo'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'road_segment_id': roadSegmentId,
      'lighting_score': lightingScore,
      'activity_score': activityScore,
      'emergency_access_score': emergencyAccessScore,
      'open_business_score': openBusinessScore,
      'road_quality_score': roadQualityScore,
      'isolation_score': isolationScore,
      'hazard_score': hazardScore,
      'risk_signal_score': riskSignalScore,
      'confidence': confidence,
      'freshness_timestamp': freshnessTimestamp?.toIso8601String(),
      'source': source,
      'source_id': sourceId,
      'is_demo': isDemo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SafetyFeature copyWith({
    String? id,
    String? roadSegmentId,
    double? lightingScore,
    double? activityScore,
    double? emergencyAccessScore,
    double? openBusinessScore,
    double? roadQualityScore,
    double? isolationScore,
    double? hazardScore,
    double? riskSignalScore,
    double? confidence,
    DateTime? freshnessTimestamp,
    String? source,
    String? sourceId,
    bool? isDemo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SafetyFeature(
      id: id ?? this.id,
      roadSegmentId: roadSegmentId ?? this.roadSegmentId,
      lightingScore: lightingScore ?? this.lightingScore,
      activityScore: activityScore ?? this.activityScore,
      emergencyAccessScore: emergencyAccessScore ?? this.emergencyAccessScore,
      openBusinessScore: openBusinessScore ?? this.openBusinessScore,
      roadQualityScore: roadQualityScore ?? this.roadQualityScore,
      isolationScore: isolationScore ?? this.isolationScore,
      hazardScore: hazardScore ?? this.hazardScore,
      riskSignalScore: riskSignalScore ?? this.riskSignalScore,
      confidence: confidence ?? this.confidence,
      freshnessTimestamp: freshnessTimestamp ?? this.freshnessTimestamp,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
