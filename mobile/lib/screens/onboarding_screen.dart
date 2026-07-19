import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _buildImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Image.asset(
        imagePath,
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.potatoPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.eco,
              size: 100,
              color: AppColors.potatoPrimary.withValues(alpha: 0.5),
            ),
          );
        },
      ),
    );
  }

  PageDecoration _buildDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? AppColors.darkText : AppColors.lightText,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: isDarkMode ? AppColors.darkSubtext : AppColors.lightSubtext,
        height: 1.5,
      ),
      imagePadding: const EdgeInsets.only(top: 20),
      contentMargin: const EdgeInsets.symmetric(horizontal: 24),
      bodyPadding: const EdgeInsets.only(top: 16),
    );
  }

  Future<void> _onDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'onboarding_title_1'.tr(),
          body: 'onboarding_body_1'.tr(),
          image: _buildImage('assets/images/potato_onboarding_1.png'),
          decoration: _buildDecoration(context),
        ),
        PageViewModel(
          title: 'onboarding_title_2'.tr(),
          body: 'onboarding_body_2'.tr(),
          image: _buildImage('assets/images/potato_onboarding_2.png'),
          decoration: _buildDecoration(context),
        ),
        PageViewModel(
          title: 'onboarding_title_3'.tr(),
          body: 'onboarding_body_3'.tr(),
          image: _buildImage('assets/images/potato_onboarding_3.png'),
          decoration: _buildDecoration(context),
        ),
      ],
      onDone: () => _onDone(context),
      onSkip: () => _onDone(context),
      showSkipButton: true,
      skip: Text(
        'skip'.tr(),
        style: TextStyle(
          color: isDarkMode ? AppColors.darkSubtext : AppColors.lightSubtext,
          fontWeight: FontWeight.w500,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.potatoPrimary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.potatoPrimary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          'get_started'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        activeSize: const Size(28.0, 10.0),
        activeColor: AppColors.potatoPrimary,
        color: isDarkMode
            ? AppColors.darkSubtext.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.3),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      globalBackgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
    );
  }
}
