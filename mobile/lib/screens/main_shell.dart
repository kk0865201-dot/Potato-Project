import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/recipes_provider.dart';
import '../providers/varieties_provider.dart';
import '../routes/app_routes.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'recipes_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _redirecting = false;

  final List<Widget> _pages = const [
    HomeScreen(),
    RecipesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load everything from the Laravel API once the shell appears.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<VarietiesProvider>().load();
      context.read<RecipesProvider>().load();
      context.read<FavoritesProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // If the session expires (401 from the API), go back to the login screen.
    final auth = context.watch<AuthProvider>();
    if (auth.status == AuthStatus.unauthenticated && !_redirecting) {
      _redirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<FavoritesProvider>().reset();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      });
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        color: AppColors.potatoPrimary,
        buttonBackgroundColor: AppColors.potatoPrimary,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: const [
          Icon(Icons.home_rounded, size: 26, color: Colors.white),
          Icon(Icons.restaurant_menu_rounded, size: 26, color: Colors.white),
          Icon(Icons.favorite_rounded, size: 26, color: Colors.white),
          Icon(Icons.settings_rounded, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
