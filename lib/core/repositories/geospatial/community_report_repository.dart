import '../../models/geospatial/community_report.dart';

abstract class CommunityReportRepository {
  Future<List<CommunityReport>> getReportsForSegment(String roadSegmentId);
  Future<CommunityReport> createReport(CommunityReport report);
}
