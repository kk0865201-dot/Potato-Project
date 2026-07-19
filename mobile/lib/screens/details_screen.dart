import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../models/variety.dart';
import '../widgets/favorite_button.dart';
import '../widgets/remote_image.dart';

class DetailsScreen extends StatelessWidget {
  final Variety item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
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
            actions: [
              // Favorite toggle, synced with the backend
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: FavoriteButton(
                  variety: item,
                  inactiveColor: Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.potatoPrimary,
                      AppColors.potatoPrimaryDark,
                    ],
                  ),
                ),
                child: RemoteImage(
                  url: item.imageUrl,
                  fit: BoxFit.cover,
                  accentColor: Colors.white,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.potatoPrimary
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: AppColors.starYellow),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms),
                  const SizedBox(height: 12),

                  // Origin
                  if (item.origin != null)
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 18, color: AppColors.potatoPrimary),
                        const SizedBox(width: 6),
                        Text(
                          item.origin!,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkMode
                                ? AppColors.darkSubtext
                                : AppColors.lightSubtext,
                          ),
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(
                    color: isDarkMode
                        ? AppColors.darkCard
                        : Colors.grey[200],
                  ),
                  const SizedBox(height: 16),

                  // Description title
                  Text(
                    'details_about'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // Description (from the API)
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: isDarkMode
                          ? AppColors.darkSubtext
                          : AppColors.lightSubtext,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),

                  // Info cards
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.eco,
                          label: 'details_type'.tr(),
                          value: item.type,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.restaurant,
                          label: 'details_best_for'.tr(),
                          value: item.bestFor,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.public,
                          label: 'details_origin'.tr(),
                          value: item.origin ?? '—',
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        duration: 500.ms,
                      ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.potatoCream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.potatoPrimary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode
                  ? AppColors.darkSubtext
                  : AppColors.lightSubtext,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
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
