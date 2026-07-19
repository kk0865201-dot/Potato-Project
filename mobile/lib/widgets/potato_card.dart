import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../models/variety.dart';
import 'favorite_button.dart';
import 'remote_image.dart';

class PotatoCard extends StatelessWidget {
  final Variety item;
  final VoidCallback onTap;

  const PotatoCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
          onTap: onTap,
          child: Container(
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
                // Image area with the favorite heart on top
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.potatoPrimaryDark
                                  .withValues(alpha: 0.2)
                              : AppColors.potatoCream,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: RemoteImage(
                            url: item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isDarkMode ? Colors.black : Colors.white)
                                .withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: FavoriteButton(variety: item, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.potatoPrimary,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                item.origin ?? item.type,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDarkMode
                                      ? AppColors.darkSubtext
                                      : AppColors.lightSubtext,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.starYellow,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item.rating.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
