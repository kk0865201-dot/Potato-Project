import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Sanctum bearer token so the user stays logged in
/// between app launches.
class TokenStorage {
  static const String _tokenKey = 'auth_token';

  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
