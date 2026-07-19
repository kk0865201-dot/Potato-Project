import 'package:flutter/material.dart';

import '../screens/favorites_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';

/// Central route table. Detail screens that need an object argument
/// (variety / recipe) are pushed with MaterialPageRoute from their callers.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const PotatoLoginPage(),
        signup: (_) => const PotatoSignUpPage(),
        main: (_) => const MainShell(),
        favorites: (_) => const FavoritesScreen(),
        profile: (_) => const ProfileScreen(),
      };
}
