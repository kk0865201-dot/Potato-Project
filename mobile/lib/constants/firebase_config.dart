/// Configuration knobs for Firebase / Google Sign-In.
class FirebaseConfig {
  FirebaseConfig._();

  /// The **Web** OAuth client ID (client_type 3) used to obtain a
  /// Firebase-valid Google ID token.
  ///
  /// On Android this is read automatically from `google-services.json`, so it
  /// can stay empty. Only set it (or pass
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`) if Google sign-in comes back
  /// with a null ID token.
  static const String googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
}
