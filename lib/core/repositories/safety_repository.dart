import '../models/safety_models.dart';
import '../models/report_model.dart';

/// Abstract safety repository.
/// Supabase implementation will replace the mock in a later phase.
abstract class SafetyRepository {
  Future<SafetyStatusModel> getCurrentSafetyStatus();
  Future<List<PointOfInterest>> getNearbyAssistance({PoiCategory? category});
  Future<void> submitReport(SafetyReport report);
}
