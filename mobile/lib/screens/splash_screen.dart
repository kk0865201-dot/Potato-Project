import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/potato_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }

    // Auto-login: if a valid token is stored, skip the login screen.
    final isLoggedIn = await context.read<AuthProvider>().tryAutoLogin();
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.main : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PotatoBackground(
        opacity: 0.10,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated potato logo from the web app.
            Image.asset(
              'assets/images/logo.gif',
              width: 180,
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.potatoPrimary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 80,
                    color: AppColors.potatoPrimary,
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 24),

            // App Name
            Text(
              'Potato App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.potatoPrimary,
                letterSpacing: 1.5,
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms),
            const SizedBox(height: 8),

            // Tagline
            Text(
              '🥔',
              style: TextStyle(
                fontSize: 40,
              ),
            ).animate(delay: 800.ms).fadeIn(duration: 500.ms),
          ],
        ),
        ),
      ),
    );
  }
}
