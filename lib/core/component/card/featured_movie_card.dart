import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class FeaturedMovieCard extends StatelessWidget {
  final String title;
  final String duration;
  final String imageUrl;
  final VoidCallback? onWatchTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked; // Add this parameter

  const FeaturedMovieCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imageUrl,
    this.onWatchTap,
    this.onBookmarkTap,
    this.isBookmarked = false, // Add default value
  });

  // Cache static gradient to avoid recreation
  static const _watchButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.red2, AppColors.red],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image with RepaintBoundary
          RepaintBoundary(
            child: CommonImage(
              imageSrc: imageUrl,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 24.r,
              fill: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: GestureDetector(
              onTap: onBookmarkTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: onWatchTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(50.r),
                  gradient: _watchButtonGradient,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Watch',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    4.width,
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.white,
                        size: 12.sp,
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

class MiniFeaturedMovieCard extends StatelessWidget {
  final String title;
  final String duration;
  final String imageUrl;
  final VoidCallback? onWatchTap;
  final VoidCallback? onBookmarkTap;

  const MiniFeaturedMovieCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imageUrl,
    this.onWatchTap,
    this.onBookmarkTap,
  });

  // Cache static gradient to avoid recreation
  static const _watchButtonGradient = LinearGradient(
    colors: [AppColors.red2, AppColors.red],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image with RepaintBoundary
          RepaintBoundary(
            child: CommonImage(
              imageSrc: imageUrl,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 16.r,
              fill: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.15),
                    AppColors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Title
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                4.height,
                Text(
                  duration,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                8.height,
                // Buttons Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBookmarkTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.bookmark_border,
                          color: AppColors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onWatchTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: _watchButtonGradient,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Watch',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            3.width,
                            Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.white,
                              size: 10.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
