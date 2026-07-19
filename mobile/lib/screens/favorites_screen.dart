import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../widgets/potato_card.dart';
import '../widgets/status_view.dart';
import 'details_screen.dart';

/// Shows only the varieties the user favorited — loaded from the Laravel
/// backend, so the list is the same on every device.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<FavoritesProvider>();

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
                'favorites_title'.tr(),
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
                isEmpty: provider.isEmpty,
                error: provider.error,
                onRetry: () => context.read<FavoritesProvider>().load(),
                emptyTitleKey: 'favorites_empty',
                emptySubtitleKey: 'favorites_empty_hint',
                emptyIcon: Icons.favorite_border_rounded,
                child: RefreshIndicator(
                  color: AppColors.potatoPrimary,
                  onRefresh: () => context.read<FavoritesProvider>().load(),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return PotatoCard(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(item: item),
                            ),
                          );
                        },
                      );
                    },
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
