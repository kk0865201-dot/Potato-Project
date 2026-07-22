import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/firebase_config.dart';

/// Thrown for any authentication failure, carrying a user-friendly [message].
/// [cancelled] is true when the user simply dismissed the Google dialog — the
/// UI should treat that as a no-op, not an error.
class AuthException implements Exception {
  final String message;
  final bool cancelled;

  const AuthException(this.message, {this.cancelled = false});

  @override
  String toString() => 'AuthException: $message';
}

/// Thin wrapper around Firebase Authentication: email/password sign-up and
/// sign-in, Google Sign-In (via `google_sign_in` 7.x), sign-out, and the
/// auth-state stream — all with friendly error messages.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleReady = false;

  /// The currently signed-in Firebase user, or null. Firebase persists this
  /// across app launches, which is what powers auto-login.
  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  /// "Continue with Google" — Firebase + Google Sign-In.
  ///
  /// The web and mobile paths differ on purpose: `google_sign_in` 7.x does
  /// **not** support programmatic `authenticate()` on the web (it expects a
  /// rendered Google button), so calling it there throws `UnsupportedError`.
  /// On web we use Firebase's own Google popup instead — no `google_sign_in`
  /// session involved. On mobile we use `google_sign_in` and exchange its ID
  /// token for a Firebase credential.
  Future<User> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final result = await _auth.signInWithPopup(GoogleAuthProvider());
        return result.user!;
      }

      await _ensureGoogleReady();

      // Trigger the interactive Google account chooser.
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Exchange the Google ID token for a Firebase credential.
      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return result.user!;
    } on GoogleSignInException catch (e) {
      // The user closed the native picker — not a real error.
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('', cancelled: true);
      }
      throw const AuthException('Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      // The user dismissed the web popup — treat as a no-op, not an error.
      if (_isPopupCancellation(e.code)) {
        throw const AuthException('', cancelled: true);
      }
      throw AuthException(_messageFor(e));
    } catch (_) {
      // Any other platform/runtime error (e.g. an unsupported-platform call):
      // surface a friendly message so the UI never hangs on an uncaught error.
      throw const AuthException('Google sign-in failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Only the mobile google_sign_in flow holds a session to clear. On web we
    // use Firebase's popup (there is no google_sign_in session), and calling
    // signOut() there — or before initialize() — can stall or throw, so guard
    // it and never let it block the Firebase sign-out above.
    if (!kIsWeb && _googleReady) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Best-effort — a Google sign-out failure must not block logout.
      }
    }
  }

  /// Web popup dismissals that Firebase reports as errors but we treat as
  /// user cancellations (a no-op), not failures worth surfacing.
  bool _isPopupCancellation(String code) {
    return code == 'popup-closed-by-user' ||
        code == 'cancelled-popup-request' ||
        code == 'web-context-cancelled' ||
        code == 'user-cancelled';
  }

  /// google_sign_in 7.x requires a one-time initialize() before use.
  Future<void> _ensureGoogleReady() async {
    if (_googleReady) return;
    const serverClientId = FirebaseConfig.googleServerClientId;
    await GoogleSignIn.instance.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _googleReady = true;
  }

  /// Maps Firebase error codes to short, user-friendly messages.
  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        // Firebase projects created after Sept 2023 return 'invalid-credential'
        // for both wrong email and wrong password (email-enumeration protection).
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'That email is already registered. Try signing in instead.';
      case 'weak-password':
        return 'Password is too weak — use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
