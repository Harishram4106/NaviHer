import '../../models/user_model.dart';
import '../profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  UserModel _profile = const UserModel(
    id: 'mock_user_123',
    name: 'Sarah Connor',
    email: 'sarah@example.com',
  );

  @override
  Future<UserModel> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profile;
  }

  @override
  Future<void> updateProfile(UserModel profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = profile;
  }
}
