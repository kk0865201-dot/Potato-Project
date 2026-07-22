import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../constants/api_constants.dart';
import '../constants/app_colors.dart';

/// The interactive 3D potato from the web app's hero, brought into the mobile
/// app. Renders the exact same baked `potato.glb` with drag-to-rotate,
/// pinch-to-zoom and auto-rotate — the same model the website shows.
///
/// Uses `model_viewer_plus`, which hosts Google's `<model-viewer>` in an
/// embedded WebView. The camera framing is left to `<model-viewer>` (auto),
/// so the tuber is always fitted to the panel, and the background is opaque
/// (a transparent WebView background renders blank on some Android devices).
class Potato3DViewer extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;

  const Potato3DViewer({
    super.key,
    this.height = 300,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.potatoPrimary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ModelViewer(
              // Fully API-driven: the model is fetched from the backend at
              // `/api/v1/media/models/potato.glb`. That route sends CORS headers
              // (config/cors.php), which the model-viewer WebView requires for a
              // cross-origin .glb — on both mobile and web.
              src: '${ApiConstants.baseUrl}/api/v1/media/models/potato.glb',
              alt: 'A 3D model of a potato',
              ar: false,
              // Load immediately instead of waiting for a "visible" signal —
              // that visibility gating is what left the model blank inside the
              // WebView on device.
              loading: Loading.eager,
              reveal: Reveal.auto,
              autoRotate: true,
              autoRotateDelay: 0,
              rotationPerSecond: '30deg',
              cameraControls: true,
              disableZoom: false,
              // Angle only — let <model-viewer> auto-compute the distance so the
              // model is always framed (a fixed metre radius can hide it).
              cameraOrbit: '0deg 75deg auto',
              interactionPrompt: InteractionPrompt.none,
              shadowIntensity: 1,
              // Opaque warm cream — matches the web viewer panel and avoids the
              // blank-WebView issue transparent backgrounds cause on Android.
              backgroundColor: const Color(0xFFFBF3E2),
            ),
          ),

          // Hint chip, echoing the web viewer's "Drag to rotate".
          Positioned(
            left: 12,
            top: 12,
            child: IgnorePointer(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.threesixty_rounded,
                      size: 16,
                      color: AppColors.potatoAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'viewer_hint'.tr(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.potatoAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
