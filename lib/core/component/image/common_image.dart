
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testemu/core/constants/app_colors.dart';

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

  const CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height,
    this.borderRadius = 0,
    this.width,
    this.size,
    this.fill = BoxFit.contain,
    this.defaultImage = AppImages.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc.contains("assets/icons")) {
      return _buildSvgImage();
    } else if (imageSrc.contains("assets/images")) {
      return _buildPngImage();
    } else {
      return _buildNetworkImage();
    }
  }

  Widget _buildErrorWidget() {
    return Image.asset(defaultImage);
  }

  // Helper function to safely convert double to int, returns null for invalid or <=0 values
  int? _safeToInt(double? value) {
    if (value == null || !value.isFinite || value <= 0) return null;
    return value.toInt();
  }

  int? _getOptimizedCacheSize(double? value) {
    final intValue = _safeToInt(value);
    if (intValue == null) return null;
    if (intValue > 800) return 400;
    if (intValue > 400) return 300;
    return intValue;
  }

  Widget _buildNetworkImage() {
    final actualWidth = size ?? width;
    final actualHeight = size ?? height;

    return CachedNetworkImage(
      height: actualHeight,
      width: actualWidth,
      imageUrl: imageSrc,
      fit: fill,
      memCacheWidth: _getOptimizedCacheSize(actualWidth),
      memCacheHeight: _getOptimizedCacheSize(actualHeight),
      maxWidthDiskCache: _safeToInt(actualWidth),
      maxHeightDiskCache: _safeToInt(actualHeight),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(image: imageProvider, fit: fill),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(
        value: downloadProgress.progress,
        color: AppColors.red2,
      ),
      errorWidget: (context, url, error) {
        errorLog(error, source: "Common Image");
        return _buildErrorWidget();
      },
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

  Widget _buildPngImage() {
    final actualWidth = size ?? width;
    final actualHeight = size ?? height;

    if (borderRadius > 0) {
      return Container(
        height: actualHeight,
        width: actualWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          imageSrc,
          color: imageColor,
          height: actualHeight,
          width: actualWidth,
          fit: fill,
          cacheHeight: _safeToInt(actualHeight),
          cacheWidth: _safeToInt(actualWidth),
          errorBuilder: (context, error, stackTrace) {
            errorLog(error, source: "Common Image");
            return _buildErrorWidget();
          },
        ),
      );
    }

    return Image.asset(
      imageSrc,
      color: imageColor,
      height: actualHeight,
      width: actualWidth,
      fit: fill,
      cacheHeight: _safeToInt(actualHeight),
      cacheWidth: _safeToInt(actualWidth),
      errorBuilder: (context, error, stackTrace) {
        errorLog(error, source: "Common Image");
        return _buildErrorWidget();
      },
    );
  }
}




// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:testemu/core/constants/app_colors.dart';

// import '../../constants/app_images.dart';
// import '../../utils/log/error_log.dart';

// class CommonImage extends StatelessWidget {
//   final String imageSrc;
//   final String defaultImage;
//   final Color? imageColor;
//   final double? height;
//   final double? width;
//   final double borderRadius;
//   final double? size;

//   final BoxFit fill;

//   const CommonImage({
//     required this.imageSrc,
//     this.imageColor,
//     this.height,
//     this.borderRadius = 0,
//     this.width,
//     this.size,
//     this.fill = BoxFit.contain,
//     this.defaultImage = AppImages.profile,
//     super.key,
//   });

//   checkImageType() {}

//   @override
//   Widget build(BuildContext context) {
//     if (imageSrc.contains("assets/icons")) {
//       return _buildSvgImage();
//     } else if (imageSrc.contains("assets/images")) {
//       return _buildPngImage();
//     } else {
//       return _buildNetworkImage();
//     }
//   }

//   Widget _buildErrorWidget() {
//     return Image.asset(defaultImage);
//   }

//   Widget _buildNetworkImage() {
//     final actualWidth = size ?? width;
//     final actualHeight = size ?? height;

//     // Helper function to safely convert to int only if finite
//     int? safeToInt(double? value) {
//       if (value == null) return null;
//       if (!value.isFinite) return null;
//       return value.toInt();
//     }

//     // Optimize cache size for carousel images - limit to 300px for better performance
//     // This reduces memory usage and improves raster thread performance
//     int? getOptimizedCacheSize(double? value) {
//       if (value == null) return null;
//       if (!value.isFinite) return null;
//       final intValue = value.toInt();
//       // Limit cache size to 400px max to reduce GPU load
//       // For very large images, scale down more aggressively
//       if (intValue > 800) return 400;
//       if (intValue > 400) return 300;
//       return intValue;
//     }

//     return CachedNetworkImage(
//       height: actualHeight,
//       width: actualWidth,
//       imageUrl: imageSrc,
//       fit: fill,
//       // Use optimized cache sizes to reduce memory and GPU load
//       memCacheWidth: getOptimizedCacheSize(actualWidth),
//       memCacheHeight: getOptimizedCacheSize(actualHeight),
//       maxWidthDiskCache: safeToInt(actualWidth),
//       maxHeightDiskCache: safeToInt(actualHeight),
//       imageBuilder: (context, imageProvider) => Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius),
//           image: DecorationImage(image: imageProvider, fit: fill),
//         ),
//       ),
//       progressIndicatorBuilder: (context, url, downloadProgress) =>
//           CircularProgressIndicator(
//             value: downloadProgress.progress,
//             color: AppColors.red2,
//           ),
//       errorWidget: (context, url, error) {
//         errorLog(error, source: "Common Image");
//         return _buildErrorWidget();
//       },
//     );
//   }

//   Widget _buildSvgImage() {
//     return SvgPicture.asset(
//       imageSrc,
//       // ignore: deprecated_member_use
//       color: imageColor,
//       height: size ?? height,
//       width: size ?? width,
//       fit: fill,
//     );
//   }

//   Widget _buildPngImage() {
//     // Helper function to safely convert to int only if finite
//     int? safeToInt(double? value) {
//       if (value == null) return null;
//       if (!value.isFinite) return null;
//       return value.toInt();
//     }

//     final actualWidth = size ?? width;
//     final actualHeight = size ?? height;

//     if (borderRadius > 0) {
//       // Only use Container with decoration when borderRadius is needed
//       return Container(
//         height: actualHeight,
//         width: actualWidth,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Image.asset(
//           imageSrc,
//           color: imageColor,
//           height: actualHeight,
//           width: actualWidth,
//           fit: fill,
//           cacheHeight: safeToInt(actualHeight),
//           cacheWidth: safeToInt(actualWidth),
//           errorBuilder: (context, error, stackTrace) {
//             errorLog(error, source: "Common Image");
//             return _buildErrorWidget();
//           },
//         ),
//       );
//     }
//     // No borderRadius - skip clipping entirely for better performance
//     return Image.asset(
//       imageSrc,
//       color: imageColor,
//       height: actualHeight,
//       width: actualWidth,
//       fit: fill,
//       cacheHeight: safeToInt(actualHeight),
//       cacheWidth: safeToInt(actualWidth),
//       errorBuilder: (context, error, stackTrace) {
//         errorLog(error, source: "Common Image");
//         return _buildErrorWidget();
//       },
//     );
//   }
// }
