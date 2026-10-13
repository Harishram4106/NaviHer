import '../models/user_preference_model.dart';

abstract class UserPreferencesRepository {
  Future<UserPreference> getPreferences(String userId);
  Future<void> updatePreferences(UserPreference preferences);
}
