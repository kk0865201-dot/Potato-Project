import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'logout'.tr(),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Revokes the Sanctum token server-side and clears the stored session.
    context.read<FavoritesProvider>().reset();
    await context.read<AuthProvider>().logout();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header
              Text(
                'settings_title'.tr(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode ? AppColors.darkText : AppColors.lightText,
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 30),

              // Account section
              _buildSectionTitle('settings_account'.tr(), isDarkMode),
              const SizedBox(height: 12),

              // Profile card (from the API)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.potatoPrimary,
                        AppColors.potatoPrimaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        child: Text(
                          user != null && user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '🥔',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 50.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 12),

              // Logout
              GestureDetector(
                onTap: _confirmLogout,
                child: _buildSettingCard(
                  icon: Icons.logout_rounded,
                  title: 'logout'.tr(),
                  subtitle: 'logout_subtitle'.tr(),
                  isDarkMode: isDarkMode,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.redAccent,
                  ),
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 24),

              // Appearance section
              _buildSectionTitle(
                  'settings_appearance'.tr(), isDarkMode),
              const SizedBox(height: 12),

              // Dark mode toggle
              _buildSettingCard(
                icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'settings_dark_mode'.tr(),
                subtitle: isDarkMode
                    ? 'settings_dark_on'.tr()
                    : 'settings_dark_off'.tr(),
                trailing: Switch(
                  value: isDarkMode,
                  activeThumbColor: AppColors.potatoPrimary,
                  onChanged: (value) {
                    context.read<ThemeProvider>().toggle(context);
                  },
                ),
                isDarkMode: isDarkMode,
              ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 24),

              // Language section
              _buildSectionTitle(
                  'settings_language'.tr(), isDarkMode),
              const SizedBox(height: 12),

              // Language toggle
              _buildSettingCard(
                icon: Icons.language,
                title: 'settings_lang_switch'.tr(),
                subtitle: isArabic
                    ? 'settings_lang_arabic'.tr()
                    : 'settings_lang_english'.tr(),
                trailing: Switch(
                  value: isArabic,
                  activeThumbColor: AppColors.potatoPrimary,
                  onChanged: (value) {
                    if (value) {
                      context.setLocale(const Locale('ar'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                ),
                isDarkMode: isDarkMode,
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 24),

              // About section
              _buildSectionTitle('settings_about'.tr(), isDarkMode),
              const SizedBox(height: 12),

              _buildSettingCard(
                icon: Icons.info_outline,
                title: 'settings_app_version'.tr(),
                subtitle: 'v2.0.0 — Potato Edition 🥔',
                isDarkMode: isDarkMode,
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 12),

              _buildSettingCard(
                icon: Icons.eco,
                title: 'settings_about_app'.tr(),
                subtitle: 'settings_about_desc'.tr(),
                isDarkMode: isDarkMode,
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 12),

              _buildSettingCard(
                icon: Icons.code,
                title: 'settings_developer'.tr(),
                subtitle: 'settings_developer_name'.tr(),
                isDarkMode: isDarkMode,
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms).slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.potatoPrimary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black12
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.potatoPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.potatoPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.darkSubtext
                        : AppColors.lightSubtext,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
