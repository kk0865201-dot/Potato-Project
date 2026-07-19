import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/api_exception.dart';
import '../utils/view_state.dart';

/// Reusable loading / error / empty handling for API-backed screens.
/// Shows a spinner while loading, an error card with a retry button on
/// failure, an empty-state message when there is no data, and otherwise
/// the actual content.
class StatusView extends StatelessWidget {
  final ViewState state;
  final bool isEmpty;
  final ApiException? error;
  final VoidCallback onRetry;
  final String emptyTitleKey;
  final String? emptySubtitleKey;
  final IconData emptyIcon;
  final Widget child;

  const StatusView({
    super.key,
    required this.state,
    required this.isEmpty,
    required this.onRetry,
    required this.child,
    this.error,
    this.emptyTitleKey = 'no_results',
    this.emptySubtitleKey,
    this.emptyIcon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if ((state == ViewState.loading || state == ViewState.idle) && isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.potatoPrimary),
      );
    }

    if (state == ViewState.error && isEmpty) {
      final message =
          error?.serverMessage ?? (error?.translationKey ?? 'error_unknown').tr();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: AppColors.potatoPrimary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode
                      ? AppColors.darkSubtext
                      : AppColors.lightSubtext,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.potatoPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (state == ViewState.loaded && isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon,
                size: 64,
                color: AppColors.potatoPrimary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitleKey.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              if (emptySubtitleKey != null) ...[
                const SizedBox(height: 8),
                Text(
                  emptySubtitleKey!.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? AppColors.darkSubtext
                        : AppColors.lightSubtext,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return child;
  }
}
