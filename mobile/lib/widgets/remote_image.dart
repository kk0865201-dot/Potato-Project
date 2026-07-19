import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Shows a potato photo, preferring the copy **bundled inside the app** so
/// images always render — offline, on web (no CORS), and with no dependency on
/// the Laravel server or any external media.
///
/// The API still drives the data; this widget just maps the API `image_url`
/// (e.g. `.../assets/photos/russet.jpg`) to the matching bundled asset
/// `assets/photos/russet.jpg`. If a photo isn't bundled (e.g. a brand-new item
/// added on the server), it falls back to the network URL, then to an icon.
class RemoteImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Tint for the placeholder spinner and the final fallback icon.
  final Color accentColor;

  /// Icon shown only when neither a bundled asset nor the network image loads.
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

  /// `assets/photos/<filename>` derived from the last path segment of [url].
  String? get _assetPath {
    final name = Uri.tryParse(url)?.pathSegments.lastOrNull;
    if (name == null || name.isEmpty) return null;
    return 'assets/photos/$name';
  }

  @override
  Widget build(BuildContext context) {
    final asset = _assetPath;

    // Bundled asset first — instant, offline, and CORS-free on web.
    if (asset != null) {
      return Image.asset(
        asset,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _networkOrIcon(),
      );
    }
    return _networkOrIcon();
  }

  /// Only reached when the photo isn't part of the app bundle.
  Widget _networkOrIcon() {
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
      errorWidget: (context, url, error) => _icon(),
    );
  }

  Widget _icon() => Center(
        child: Icon(
          fallbackIcon,
          size: 48,
          color: accentColor.withValues(alpha: 0.6),
        ),
      );
}
