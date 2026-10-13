import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/geospatial/community_report.dart';
import '../../../core/models/geospatial/coordinate_utils.dart';
import '../../../core/providers/repository_providers.dart';

final communityReportNotifierProvider = StateNotifierProvider<CommunityReportNotifier, AsyncValue<void>>((ref) {
  return CommunityReportNotifier(ref);
});

class CommunityReportNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  CommunityReportNotifier(this._ref) : super(const AsyncData(null));

  Future<void> submitReport({
    required String category,
    required String description,
    required bool isAnonymous,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(communityReportRepositoryProvider);
      
      final report = CommunityReport(
        id: const Uuid().v4(),
        roadSegmentId: 'unknown', // Ideally determined by current location
        category: category,
        description: description,
        confidence: 80,
        location: const Coordinate(latitude: 37.7749, longitude: -122.4194),
        moderationStatus: ModerationStatus.pending,
        reportedAt: DateTime.now(),
        isDemo: true,
      );
      
      await repo.createReport(report);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
