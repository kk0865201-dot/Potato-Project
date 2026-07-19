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
import '../widgets/primary_button.dart';

class PotatoSignUpPage extends StatefulWidget {
  const PotatoSignUpPage({super.key});

  @override
  State<PotatoSignUpPage> createState() => _PotatoSignUpPageState();
}

class _PotatoSignUpPageState extends State<PotatoSignUpPage> {
  bool isChecked = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
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

  Future<void> _handleSignUp() async {
    // Validate name
    if (_nameController.text.trim().isEmpty) {
      _showError('validation_name'.tr());
      return;
    }
    // Validate email
    if (_emailController.text.trim().isEmpty) {
      _showError('validation_email'.tr());
      return;
    }
    // Validate password
    if (_passwordController.text.trim().isEmpty) {
      _showError('validation_password'.tr());
      return;
    }
    // Validate password match
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('validation_password_match'.tr());
      return;
    }
    // Validate terms
    if (!isChecked) {
      _showError('validation_terms'.tr());
      return;
    }

    try {
      // Create a real Firebase user (email + password) and sign in directly.
      await context.read<AuthProvider>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isBusy = context.watch<AuthProvider>().isBusy;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language,
                color: AppColors.potatoPrimary),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'potato_up'.tr(),
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 30),

            // Full name
            AppTextField(
              hintTextKey: 'potato_name',
              prefixIcon: Icons.person,
              controller: _nameController,
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 15),

            // Email
            AppTextField(
              hintTextKey: 'potato_mail',
              prefixIcon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 15),

            // Phone (optional)
            AppTextField(
              hintTextKey: 'potato_number',
              prefixIcon: Icons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 15),

            // Password
            AppTextField(
              hintTextKey: 'potato_password',
              prefixIcon: Icons.lock,
              isPassword: true,
              controller: _passwordController,
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 15),

            // Confirm password
            AppTextField(
              hintTextKey: 'confirm_potato_password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _confirmPasswordController,
            ).animate(delay: 500.ms).fadeIn(duration: 400.ms).slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 20),

            // Terms checkbox
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: AppColors.potatoPrimary,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'agree_terms'.tr(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 25),

            // Sign-up button
            PrimaryButton(
              textKey: 'sign_up_button',
              onPressed: _handleSignUp,
              isLoading: isBusy,
            ).animate(delay: 700.ms).fadeIn(duration: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 400.ms,
                ),
            const SizedBox(height: 25),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('already_have'.tr()),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'potato_in'.tr(),
                    style: const TextStyle(
                      color: AppColors.potatoPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
