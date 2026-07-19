import 'api_client.dart';

/// Raw calls to the Laravel authentication endpoints.
class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<ApiResult> register({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) {
    return _client.post('/auth/register', body: {
      'name': name,
      'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<ApiResult> login({required String email, required String password}) {
    return _client.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
  }

  /// One-tap demo access — no email or password. Always signs into the
  /// same shared "Potato" account on the backend.
  Future<ApiResult> guest() => _client.post('/auth/guest');

  /// Bridge a Firebase identity to a Laravel Sanctum token, so a
  /// Firebase-authenticated user can still authorize favorites/profile.
  Future<ApiResult> social({
    required String name,
    required String email,
    required String firebaseUid,
  }) {
    return _client.post('/auth/social', body: {
      'name': name,
      'email': email,
      'firebase_uid': firebaseUid,
    });
  }

  Future<ApiResult> logout() => _client.post('/auth/logout');

  Future<ApiResult> me() => _client.get('/auth/user');

  Future<ApiResult> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) {
    return _client.put('/auth/profile', body: {
      'name': ?name,
      'email': ?email,
      'phone': ?phone,
      if (password != null && password.isNotEmpty) 'password': password,
      if (password != null && password.isNotEmpty)
        'password_confirmation': passwordConfirmation,
    });
  }
}
