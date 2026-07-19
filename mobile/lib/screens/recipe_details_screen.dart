import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../widgets/remote_image.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.potatoPrimary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.potatoCream,
                child: RemoteImage(
                  url: recipe.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  fallbackIcon: Icons.restaurant_menu_rounded,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + tag
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? AppColors.darkText : AppColors.lightText,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    recipe.summary,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDarkMode
                          ? AppColors.darkSubtext
                          : AppColors.lightSubtext,
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Meta cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetaCard(
                          Icons.people_outline,
                          'recipe_serves'.tr(),
                          '${recipe.serves}',
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetaCard(
                          Icons.schedule,
                          'recipe_prep'.tr(),
                          recipe.prepTime,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetaCard(
                          Icons.local_fire_department_outlined,
                          'recipe_cook'.tr(),
                          recipe.cookTime,
                          isDarkMode,
                        ),
                      ),
                    ],
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),
                  _buildMetaCard(
                    Icons.eco,
                    'recipe_best'.tr(),
                    recipe.bestPotato,
                    isDarkMode,
                    fullWidth: true,
                  ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),

                  // Ingredients
                  Text(
                    'recipe_ingredients'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:
                          isDarkMode ? AppColors.darkText : AppColors.lightText,
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),
                  ...recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.circle,
                              size: 8,
                              color: AppColors.potatoPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: isDarkMode
                                    ? AppColors.darkSubtext
                                    : AppColors.lightSubtext,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Steps
                  Text(
                    'recipe_steps'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:
                          isDarkMode ? AppColors.darkText : AppColors.lightText,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),
                  ...recipe.steps.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.potatoPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: isDarkMode
                                    ? AppColors.darkSubtext
                                    : AppColors.lightSubtext,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard(
    IconData icon,
    String label,
    String value,
    bool isDarkMode, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.potatoCream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.potatoPrimary, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color:
                  isDarkMode ? AppColors.darkSubtext : AppColors.lightSubtext,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkText : AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
