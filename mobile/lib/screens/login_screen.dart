import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/potato_background.dart';
import '../widgets/primary_button.dart';

class PotatoLoginPage extends StatefulWidget {
  const PotatoLoginPage({super.key});

  @override
  State<PotatoLoginPage> createState() => _PotatoLoginPageState();
}

class _PotatoLoginPageState extends State<PotatoLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showError('validation_email'.tr());
      return;
    }
    if (password.isEmpty) {
      _showError('validation_password'.tr());
      return;
    }

    try {
      // Real sign-in with Firebase Authentication (email + password).
      await context.read<AuthProvider>().login(email, password);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted || e.cancelled) return;
      _showError(e.message);
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      // "Continue with Google" via Firebase + google_sign_in.
      await context.read<AuthProvider>().loginWithGoogle();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (route) => false,
      );
    } on AuthException catch (e) {
      // A cancelled Google picker is not an error.
      if (!mounted || e.cancelled) return;
      _showError(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isBusy = context.watch<AuthProvider>().isBusy;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.potatoPrimary),
            onPressed: () {
              if (context.locale.languageCode == 'en') {
                context.setLocale(const Locale('ar'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: AppColors.potatoPrimary,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggle(context);
            },
          ),
        ],
      ),
      body: PotatoBackground(
        child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated potato logo from the web app.
              Image.asset(
                    'assets/images/logo.gif',
                    width: 140,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.potatoPrimary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 60,
                        color: AppColors.potatoPrimary,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                  ),
              const SizedBox(height: 40),

              // Email field
              AppTextField(
                    hintTextKey: 'potato_mail',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.1, end: 0, duration: 400.ms),
              const SizedBox(height: 15),

              // Password field
              AppTextField(
                    hintTextKey: 'potato_password',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: _passwordController,
                  )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.1, end: 0, duration: 400.ms),
              const SizedBox(height: 25),

              // Login button
              PrimaryButton(
                textKey: 'potato_in',
                onPressed: _handleLogin,
                isLoading: isBusy,
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDarkMode
                          ? AppColors.darkSubtext.withValues(alpha: 0.3)
                          : Colors.grey[300],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or'.tr(),
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkSubtext
                            : AppColors.lightSubtext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDarkMode
                          ? AppColors.darkSubtext.withValues(alpha: 0.3)
                          : Colors.grey[300],
                    ),
                  ),
                ],
              ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 20),

              // Continue with Google (Firebase Auth + google_sign_in).
              OutlinedButton(
                onPressed: isBusy ? null : _handleGoogleLogin,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'continue_google'.tr(),
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 25),

              // Sign-up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('no_potato'.tr()),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: Text(
                      'potato_up'.tr(),
                      style: const TextStyle(
                        color: AppColors.potatoPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
