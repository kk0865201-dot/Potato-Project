import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// The web app's signature wallpaper: the animated potato logo (`logo.gif`)
/// tiled across the page on a light base. Here it's rendered at a low opacity
/// behind the content so screens keep the same identity while staying readable
/// in both light and dark mode.
///
/// Wrap a screen's body with this and give it a transparent [Scaffold]
/// background to let the wallpaper show through.
class PotatoBackground extends StatelessWidget {
  final Widget child;

  /// How strongly the tiled potatoes show through (0–1).
  final double opacity;

  const PotatoBackground({
    super.key,
    required this.child,
    this.opacity = 0.06,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        image: DecorationImage(
          image: const AssetImage('assets/images/logo.gif'),
          repeat: ImageRepeat.repeat,
          scale: 3.2, // ~ the web's 150px tile
          opacity: opacity,
          // Dark mode: knock the warm tiles back so they read as texture.
          colorFilter: isDarkMode
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
                  BlendMode.darken,
                )
              : null,
        ),
      ),
      child: child,
    );
  }
}
