import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/api_exception.dart';

/// Parsed body of a successful `{success, message, data, meta?}` response.
class ApiResult {
  final dynamic data;
  final String? message;
  final Map<String, dynamic>? meta;

  const ApiResult({this.data, this.message, this.meta});
}

/// The single place in the app that talks HTTP. Every service goes through
/// this client, so headers, timeouts, token handling and error mapping are
/// never duplicated.
class ApiClient {
  final http.Client _http;
  String? _token;

  /// Current UI language (e.g. 'en' / 'ar'), sent as `Accept-Language` so the
  /// backend returns localized content.
  String _languageCode = 'en';

  /// Called when an authenticated request comes back 401 — the session
  /// expired or the token was revoked. AuthProvider hooks into this.
  void Function()? onSessionExpired;

  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  set token(String? value) => _token = value;
  bool get hasToken => _token != null;

  set languageCode(String value) => _languageCode = value;

  Future<ApiResult> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<ApiResult> post(String path, {Map<String, dynamic>? body}) =>
      _send('POST', path, body: body);

  Future<ApiResult> put(String path, {Map<String, dynamic>? body}) =>
      _send('PUT', path, body: body);

  Future<ApiResult> delete(String path) => _send('DELETE', path);

  Future<ApiResult> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    var uri = Uri.parse('${ApiConstants.apiUrl}$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }

    try {
      final request = http.Request(method, uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': _languageCode,
        if (_token != null) 'Authorization': 'Bearer $_token',
      });
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamed =
          await _http.send(request).timeout(ApiConstants.requestTimeout);
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(type: ApiErrorType.network);
    } on TimeoutException {
      throw const ApiException(type: ApiErrorType.timeout);
    } on http.ClientException {
      throw const ApiException(type: ApiErrorType.network);
    }
  }

  ApiResult _handleResponse(http.Response response) {
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) json = decoded;
    } catch (_) {
      // Non-JSON body (e.g. an HTML error page) — fall through to error below.
    }

    final ok = response.statusCode >= 200 && response.statusCode < 300;
    if (ok && json?['success'] == true) {
      return ApiResult(
        data: json!['data'],
        message: json['message'] as String?,
        meta: (json['meta'] as Map?)?.cast<String, dynamic>(),
      );
    }

    // Only trust the message when it comes from our standardized envelope.
    final serverMessage = json?['success'] == false
        ? (json?['message'] as String?)
        : null;
    final errors = (json?['errors'] as Map?)?.cast<String, dynamic>();

    final type = switch (response.statusCode) {
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      422 => ApiErrorType.validation,
      >= 500 => ApiErrorType.server,
      _ => ApiErrorType.unknown,
    };

    // A 401 on a request that carried a token means the session went stale.
    if (type == ApiErrorType.unauthorized && _token != null) {
      onSessionExpired?.call();
    }

    throw ApiException(
      type: type,
      statusCode: response.statusCode,
      serverMessage: serverMessage,
      errors: errors,
    );
  }
}
