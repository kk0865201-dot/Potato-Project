import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Shows a photo fetched from the backend API.
///
/// The app is fully API-driven: photos come from the Laravel backend via
/// `image_url` (served under `/api/v1/media/...`, which carries CORS headers so
/// it also works on the web build). `cached_network_image` caches each photo
/// on-device after the first load. A spinner shows while loading and a friendly
/// icon if the image can't be fetched.
class RemoteImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Tint for the loading spinner and the fallback icon.
  final Color accentColor;

  /// Icon shown when the image can't be loaded.
  final IconData fallbackIcon;

  const RemoteImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.accentColor = AppColors.potatoPrimary,
    this.fallbackIcon = Icons.eco,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, _) => Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: accentColor),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          fallbackIcon,
          size: 48,
          color: accentColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
