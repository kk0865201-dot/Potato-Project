import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api_exception.dart';
import '../models/variety.dart';
import '../providers/favorites_provider.dart';

/// Heart icon used on cards and detail pages. Toggles the variety in the
/// server-synced favorites list; shows a snackbar if the request fails.
class FavoriteButton extends StatelessWidget {
  final Variety variety;
  final double size;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.variety,
    this.size = 22,
    this.inactiveColor,
  });

  Future<void> _toggle(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<FavoritesProvider>().toggle(variety);
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.serverMessage ?? e.translationKey.tr()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(variety.id);

    return IconButton(
      onPressed: () => _toggle(context),
      visualDensity: VisualDensity.compact,
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: size,
        color: isFavorite
            ? Colors.redAccent
            : (inactiveColor ?? Colors.grey),
      ),
    );
  }
}
