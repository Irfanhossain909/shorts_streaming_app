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

  const FeaturedMovieCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imageUrl,
    this.onWatchTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: CommonImage(
              imageSrc: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fill: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.2),
                  AppColors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 22.h),
            child: Column(
              children: [
                const Spacer(),
                // Title and duration centered
                Column(
                  children: [
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 8,
                        height: 1.1,
                      ),
                    ),
                    12.height,
                    Text(
                      duration,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                24.height,
                // Buttons row
                Row(
                  children: [
                    // Bookmark button (left)
                    GestureDetector(
                      onTap: onBookmarkTap,
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
                          Icons.bookmark_border,
                          color: AppColors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Watch button (right)
                    GestureDetector(
                      onTap: onWatchTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(50.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.red2, AppColors.red],
                          ),
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
