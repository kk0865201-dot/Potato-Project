import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

import '../models/api_exception.dart';
import '../models/user.dart' as app;
import '../repositories/auth_repository.dart';
import '../services/api_client.dart';
import '../services/firebase_auth_service.dart';

enum AuthStatus { unknown, authenticating, authenticated, unauthenticated }

/// Owns the login session. **Firebase Authentication** is the source of truth
/// for who is signed in (email/password or Google) and for auto-login. After a
/// successful Firebase sign-in the provider bridges the identity to the Laravel
/// backend (`/auth/social`) to obtain a Sanctum token, so the same session can
/// authorize the data endpoints (favorites, profile).
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _firebase;
  final AuthRepository _repository;
  final ApiClient _apiClient;

  app.User? _user;
  AuthStatus _status = AuthStatus.unknown;

  AuthProvider(this._firebase, this._repository, this._apiClient);

  app.User? get user => _user;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isBusy => _status == AuthStatus.authenticating;

  /// Auto-login: Firebase persists the session, so if a user is still signed
  /// in we skip the login screen. Returns true when a user is restored.
  Future<bool> tryAutoLogin() async {
    final current = _firebase.currentUser;
    if (current == null) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
    await _bridgeToBackend(current);
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<void> login(String email, String password) {
    return _authenticate(
      () => _firebase.signIn(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authenticate(
      () => _firebase.signUp(
        email: email,
        password: password,
        displayName: name,
      ),
      nameHint: name,
    );
  }

  /// "Continue with Google".
  Future<void> loginWithGoogle() {
    return _authenticate(() => _firebase.signInWithGoogle());
  }

  Future<void> _authenticate(
    Future<User> Function() firebaseAction, {
    String? nameHint,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      final firebaseUser = await firebaseAction();
      await _bridgeToBackend(firebaseUser, nameHint: nameHint);
      _status = AuthStatus.authenticated;
      notifyListeners();
    } on AuthException {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  /// Exchange the Firebase identity for a Laravel token. **Non-fatal**: if the
  /// backend can't be reached, the user stays logged in via Firebase (public
  /// data still loads; only favorites/profile need the token).
  Future<void> _bridgeToBackend(User firebaseUser, {String? nameHint}) async {
    final email =
        firebaseUser.email ?? '${firebaseUser.uid}@potato.firebase';
    final name = (nameHint?.trim().isNotEmpty ?? false)
        ? nameHint!.trim()
        : (firebaseUser.displayName ?? _nameFromEmail(email));

    try {
      final session = await _repository.social(
        name: name,
        email: email,
        firebaseUid: firebaseUser.uid,
      );
      _apiClient.token = session.token;
      _user = session.user;
    } on ApiException {
      _apiClient.token = null;
      _user = app.User(id: 0, name: name, email: email);
    }
  }

  Future<void> logout() async {
    await _firebase.signOut();
    _apiClient.token = null;
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) async {
    _user = await _repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    notifyListeners();
  }

  String _nameFromEmail(String email) {
    final prefix = email.split('@').first;
    return prefix.isEmpty ? 'Potato User' : prefix;
  }
}
