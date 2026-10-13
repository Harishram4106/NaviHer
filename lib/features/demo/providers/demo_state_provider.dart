import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/route_model.dart';

enum DemoNavigationState {
  inactive,
  navigating,
  hazardDetected,
  recalculating,
  alternativeProposed,
  alternativeAccepted
}

class DemoState {
  final DemoNavigationState navigationState;
  final bool hasCommunityReport;
  final bool emergencyLocationShared;
  final bool notificationsEnabled;
  final bool emergencyModeEnabled;
  final int safetyPriority; // 0 = Safety, 1 = Time
  final List<String> trustedContacts;
  final RouteModel? activeRoute;

  DemoState({
    this.navigationState = DemoNavigationState.inactive,
    this.hasCommunityReport = false,
    this.emergencyLocationShared = false,
    this.notificationsEnabled = true,
    this.emergencyModeEnabled = false,
    this.safetyPriority = 0,
    this.trustedContacts = const ['Mom', 'Dad', 'Roommate'],
    this.activeRoute,
  });

  DemoState copyWith({
    DemoNavigationState? navigationState,
    bool? hasCommunityReport,
    bool? emergencyLocationShared,
    bool? notificationsEnabled,
    bool? emergencyModeEnabled,
    int? safetyPriority,
    List<String>? trustedContacts,
    RouteModel? activeRoute,
  }) {
    return DemoState(
      navigationState: navigationState ?? this.navigationState,
      hasCommunityReport: hasCommunityReport ?? this.hasCommunityReport,
      emergencyLocationShared: emergencyLocationShared ?? this.emergencyLocationShared,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emergencyModeEnabled: emergencyModeEnabled ?? this.emergencyModeEnabled,
      safetyPriority: safetyPriority ?? this.safetyPriority,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      activeRoute: activeRoute ?? this.activeRoute,
    );
  }
}

class DemoStateNotifier extends StateNotifier<DemoState> {
  DemoStateNotifier() : super(DemoState());

  void setNavigationState(DemoNavigationState state) {
    this.state = this.state.copyWith(navigationState: state);
  }
  
  void updateNavState(DemoNavigationState state) {
    this.state = this.state.copyWith(navigationState: state);
  }
  
  void setActiveRoute(RouteModel route) {
    state = state.copyWith(activeRoute: route, navigationState: DemoNavigationState.navigating);
  }
  
  void endNavigation() {
    state = state.copyWith(activeRoute: null, navigationState: DemoNavigationState.inactive);
  }

  void submitCommunityReport() {
    state = state.copyWith(hasCommunityReport: true);
  }

  void toggleLocationSharing(bool isShared) {
    state = state.copyWith(emergencyLocationShared: isShared);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void toggleEmergencyMode(bool enabled) {
    state = state.copyWith(emergencyModeEnabled: enabled);
  }

  void setSafetyPriority(int priority) {
    state = state.copyWith(safetyPriority: priority);
  }

  void addTrustedContact(String contact) {
    state = state.copyWith(trustedContacts: [...state.trustedContacts, contact]);
  }

  void removeTrustedContact(String contact) {
    state = state.copyWith(
      trustedContacts: state.trustedContacts.where((c) => c != contact).toList(),
    );
  }
}

final demoStateProvider = StateNotifierProvider<DemoStateNotifier, DemoState>((ref) {
  return DemoStateNotifier();
});
