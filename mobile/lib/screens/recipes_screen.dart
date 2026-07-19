import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../providers/recipes_provider.dart';
import '../widgets/remote_image.dart';
import '../widgets/status_view.dart';
import 'recipe_details_screen.dart';

/// Recipes list loaded from the Laravel API.
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  bool _onScrollNotification(
      BuildContext context, ScrollNotification notification) {
    if (notification.metrics.pixels >
        notification.metrics.maxScrollExtent - 300) {
      context.read<RecipesProvider>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RecipesProvider>();

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'recipes_title'.tr(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    duration: 400.ms,
                  ),
            ),
            Expanded(
              child: StatusView(
                state: provider.state,
                isEmpty: provider.items.isEmpty,
                error: provider.error,
                onRetry: () => context.read<RecipesProvider>().load(),
                emptyTitleKey: 'no_results',
                child: RefreshIndicator(
                  color: AppColors.potatoPrimary,
                  onRefresh: () => context.read<RecipesProvider>().load(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(context, notification),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: provider.items.length +
                          (provider.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.potatoPrimary,
                              ),
                            ),
                          );
                        }
                        return _RecipeCard(recipe: provider.items[index])
                            .animate(delay: (60 * index).ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.05, end: 0, duration: 400.ms);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black26
                  : Colors.grey.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with the tag chip on top
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.potatoCream,
                    child: RemoteImage(
                      url: recipe.imageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.restaurant_menu_rounded,
                    ),
                  ),
                ),
                if (recipe.tag.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.potatoPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDarkMode
                          ? AppColors.darkSubtext
                          : AppColors.lightSubtext,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 16, color: AppColors.potatoPrimary),
                      const SizedBox(width: 4),
                      Text(
                        '${'recipe_serves'.tr()} ${recipe.serves}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.darkSubtext
                              : AppColors.lightSubtext,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.timer_outlined,
                          size: 16, color: AppColors.potatoPrimary),
                      const SizedBox(width: 4),
                      Text(
                        recipe.cookTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.darkSubtext
                              : AppColors.lightSubtext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
