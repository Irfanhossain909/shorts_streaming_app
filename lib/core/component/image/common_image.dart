import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_images.dart';
import '../../utils/log/error_log.dart';

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final double? size;
  final BoxFit fill;

  /// Performance mode
  final bool lowQualityMode;

  /// Full HD mode - no cache size limit, loads backend resolution (use for hero/slider images)
  final bool highQuality;

  const CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height,
    this.borderRadius = 0,
    this.width,
    this.size,
    this.fill = BoxFit.cover,
    this.defaultImage = AppImages.defaultProfile,
    this.lowQualityMode = false,
    this.highQuality = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc.startsWith("assets/icons")) {
      return _buildSvgImage();
    } else if (imageSrc.startsWith("assets/images")) {
      return _buildAssetImage();
    } else {
      return _buildNetworkImage(context);
    }
  }

  int? _safeToInt(double? value) {
    if (value == null || value <= 0 || !value.isFinite) return null;
    return value.toInt();
  }

  int? _optimizedSize(double? value) {
    final v = _safeToInt(value);
    if (v == null) return null;

    if (lowQualityMode) {
      return (v * 0.6).toInt(); // reduce 40%
    }

    return v;
  }

  /// Cache at displaySize * devicePixelRatio for retina - full HD sharp images
  int? _cacheSizeForRetina(double? displaySize, double devicePixelRatio) {
    if (displaySize == null || displaySize <= 0 || !displaySize.isFinite) {
      return null;
    }
    final scaled = displaySize * devicePixelRatio;
    return _optimizedSize(scaled);
  }

  /// 🔥 DARK GLOSS SHIMMER
  Widget _buildShimmer(double? h, double? w) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Shimmer(
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 1200),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF1C1C1C),  // dark base
            const Color(0xFF2A2A2A),
            const Color(0xFF3A3A3A),  // gloss highlight
            const Color(0xFF2A2A2A),
            const Color(0xFF1C1C1C),
          ],
          stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
        ),
        child: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    final actualWidth = size ?? width;
    final actualHeight = size ?? height;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    // highQuality: full resolution from backend (no downscale)
    // else: cache at displaySize * devicePixelRatio for retina
    final cacheW = highQuality
        ? null
        : _cacheSizeForRetina(actualWidth, dpr);
    final cacheH = highQuality
        ? null
        : _cacheSizeForRetina(actualHeight, dpr);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageSrc,
        height: actualHeight,
        width: actualWidth,
        fit: fill,
        memCacheWidth: cacheW,
        memCacheHeight: cacheH,
        maxWidthDiskCache: cacheW,
        maxHeightDiskCache: cacheH,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,

        /// 🔥 Gloss Shimmer Loading
        placeholder: (context, url) =>
            _buildShimmer(actualHeight, actualWidth),

        errorWidget: (context, url, error) {
          errorLog(error, source: "CommonImage");
          return Image.asset(defaultImage, fit: fill);
        },
      ),
    );
  }

  Widget _buildSvgImage() {
    return SvgPicture.asset(
      imageSrc,
      color: imageColor,
      height: size ?? height,
      width: size ?? width,
      fit: fill,
    );
  }

  Widget _buildAssetImage() {
    final actualWidth = size ?? width;
    final actualHeight = size ?? height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        imageSrc,
        color: imageColor,
        height: actualHeight,
        width: actualWidth,
        fit: fill,
        cacheHeight: _optimizedSize(actualHeight),
        cacheWidth: _optimizedSize(actualWidth),
        errorBuilder: (context, error, stackTrace) {
          errorLog(error, source: "CommonImage");
          return Image.asset(defaultImage, fit: fill);
        },
      ),
    );
  }
}

