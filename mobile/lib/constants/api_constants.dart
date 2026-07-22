/// Central place for everything related to reaching the Laravel backend.
class ApiConstants {
  ApiConstants._();

  /// The live, deployed backend. This is the DEFAULT so the app runs with zero
  /// setup — `flutter run` shows real data without starting a server locally.
  static const String _productionBaseUrl =
      'https://potato-api-kk0865201-xkr5.onrender.com';

  /// Optional override to point at a LOCAL backend instead, e.g.:
  ///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000   (Android emulator)
  ///   flutter run --dart-define=API_BASE_URL=http://localhost:8000  (web / iOS sim)
  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl =>
      _definedBaseUrl.isNotEmpty ? _definedBaseUrl : _productionBaseUrl;

  static String get apiUrl => '$baseUrl/api/v1';

  /// Generous timeout: the free host can take up to ~50s to wake from idle on
  /// the first request of a session (responses are instant afterwards).
  static const Duration requestTimeout = Duration(seconds: 60);
  static const int defaultPerPage = 10;
}
