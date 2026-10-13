import '../../models/user_preference_model.dart';
import '../user_preferences_repository.dart';

class MockUserPreferencesRepository implements UserPreferencesRepository {
  UserPreference _preferences = const UserPreference(
    id: 'pref_1',
    userId: 'mock_user_123',
  );

  @override
  Future<UserPreference> getPreferences(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _preferences;
  }

  @override
  Future<void> updatePreferences(UserPreference preferences) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _preferences = preferences;
  }
}
