import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/repository_providers.dart';

final emergencyProvider = StateNotifierProvider<EmergencyNotifier, AsyncValue<void>>((ref) {
  return EmergencyNotifier(ref);
});

/// Manages in-app emergency actions.
///
/// MOCK MODE — no external delivery is performed.
/// The following actions are internal, state-only simulations:
///   - [notifyContacts]: reads trusted contacts from the repository and
///     simulates a notification (local state + SnackBar feedback only).
///     No SMS, push notification, or external message is sent.
///   - [shareLiveLocation]: simulates starting a location-sharing session
///     (local state + SnackBar feedback only).
///     No GPS broadcast, API call, or external location share occurs.
///
/// Real external delivery (SMS, push, live location broadcast) requires
/// platform channels (e.g. telephony, FCM) and is out of scope for this phase.
class EmergencyNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  EmergencyNotifier(this._ref) : super(const AsyncData(null));

  /// MOCK: Fetches trusted contacts and simulates alerting them.
  /// No real message is sent externally.
  Future<void> notifyContacts() async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(trustedContactsRepositoryProvider);
      // Loads contacts from the shared TrustedContactsRepository
      // (same repository used by the Profile screen — single source of truth).
      await repo.getContacts('dummy_user_id');
      
      // MOCK: Simulate sending notification to all contacts.
      // Replace with platform SMS/push channel for real delivery.
      await Future.delayed(const Duration(seconds: 1));
      
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// MOCK: Simulates starting a live location-sharing session.
  /// No GPS broadcast or external API call is performed.
  Future<void> shareLiveLocation() async {
    state = const AsyncLoading();
    try {
      // MOCK: Simulate starting a live location sharing session.
      // Replace with platform location/FCM channel for real delivery.
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
