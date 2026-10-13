import 'dart:async';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<bool>.broadcast();
  bool _isAuthenticated = false;

  MockAuthRepository() {
    _controller.add(_isAuthenticated);
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _controller.add(true);
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _controller.add(true);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _controller.add(false);
  }

  @override
  Stream<bool> get authStateChanges => _controller.stream;

  @override
  String? get currentUserId => _isAuthenticated ? 'mock_user_123' : null;

  void dispose() {
    _controller.close();
  }
}
