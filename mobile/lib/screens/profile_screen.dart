import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/api_exception.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// View and edit the profile stored on the Laravel backend.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnack('validation_name'.tr(), isError: true);
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnack('validation_email'.tr(), isError: true);
      return;
    }

    setState(() => _saving = true);
    try {
      await context.read<AuthProvider>().updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;
      _showSnack('profile_updated'.tr());
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnack(e.serverMessage ?? e.translationKey.tr(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'profile_title'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.potatoPrimary.withValues(alpha: 0.15),
              child: Text(
                user != null && user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : '🥔',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.potatoPrimary,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                ),
            const SizedBox(height: 30),

            AppTextField(
              hintTextKey: 'potato_name',
              prefixIcon: Icons.person,
              controller: _nameController,
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 15),

            AppTextField(
              hintTextKey: 'potato_mail',
              prefixIcon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 15),

            AppTextField(
              hintTextKey: 'potato_number',
              prefixIcon: Icons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 30),

            PrimaryButton(
              textKey: 'save',
              onPressed: _save,
              isLoading: _saving,
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
