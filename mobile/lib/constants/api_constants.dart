import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Central place for everything related to reaching the Laravel backend.
class ApiConstants {
  ApiConstants._();

  /// Override at build time for a physical device:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_definedBaseUrl.isNotEmpty) return _definedBaseUrl;
    if (kIsWeb) return 'http://localhost:8000';
    // Android emulators reach the host machine through 10.0.2.2.
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  static String get apiUrl => '$baseUrl/api/v1';

  static const Duration requestTimeout = Duration(seconds: 15);
  static const int defaultPerPage = 10;
}
