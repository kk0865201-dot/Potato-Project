import '../models/user.dart';
import '../services/auth_service.dart';

/// A logged-in user together with their Sanctum token.
class AuthSession {
  final User user;
  final String token;

  const AuthSession({required this.user, required this.token});
}

/// Turns raw auth API responses into typed domain objects.
class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<AuthSession> register({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _service.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return _sessionFrom(result.data as Map<String, dynamic>);
  }

  Future<AuthSession> login(String email, String password) async {
    final result = await _service.login(email: email, password: password);
    return _sessionFrom(result.data as Map<String, dynamic>);
  }

  Future<AuthSession> guest() async {
    final result = await _service.guest();
    return _sessionFrom(result.data as Map<String, dynamic>);
  }

  Future<AuthSession> social({
    required String name,
    required String email,
    required String firebaseUid,
  }) async {
    final result = await _service.social(
      name: name,
      email: email,
      firebaseUid: firebaseUid,
    );
    return _sessionFrom(result.data as Map<String, dynamic>);
  }

  Future<void> logout() => _service.logout();

  Future<User> me() async {
    final result = await _service.me();
    return User.fromJson(result.data as Map<String, dynamic>);
  }

  Future<User> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) async {
    final result = await _service.updateProfile(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return User.fromJson(result.data as Map<String, dynamic>);
  }

  AuthSession _sessionFrom(Map<String, dynamic> data) {
    return AuthSession(
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }
}
