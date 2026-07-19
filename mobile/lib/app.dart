import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/recipes_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/varieties_provider.dart';
import 'routes/app_routes.dart';
import 'services/api_client.dart';
import 'utils/view_state.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _lastLocale;

  /// Re-fetches API-backed content that has already loaded, so switching
  /// language refreshes it into the new locale.
  void _reloadLocalizedContent() {
    final varieties = context.read<VarietiesProvider>();
    if (varieties.state != ViewState.idle) varieties.load();

    final recipes = context.read<RecipesProvider>();
    if (recipes.state != ViewState.idle) recipes.load();

    final favorites = context.read<FavoritesProvider>();
    if (context.read<AuthProvider>().isAuthenticated &&
        favorites.state != ViewState.idle) {
      favorites.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().mode;

    // Keep the API client's Accept-Language in sync with the UI language, and
    // when the user switches language at runtime, reload already-fetched
    // content so it comes back in the new language.
    final locale = context.locale;
    if (_lastLocale != locale) {
      final isFirstBuild = _lastLocale == null;
      _lastLocale = locale;
      context.read<ApiClient>().languageCode = locale.languageCode;
      if (!isFirstBuild) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _reloadLocalizedContent();
        });
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.light(
          primary: AppColors.potatoPrimary,
          secondary: AppColors.potatoPrimaryLight,
          surface: AppColors.lightSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.lightText),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.potatoPrimary,
          secondary: AppColors.potatoPrimaryLight,
          surface: AppColors.darkSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkText),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
