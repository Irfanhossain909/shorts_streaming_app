import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? badge;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final String? date;
  final bool isRemindMe;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;
  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.badge,
    this.onTap,
    this.width,
    this.height,
    this.date,
    this.isRemindMe = false,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  // Cache static gradient to avoid recreation
  static const _remindMeGradient = LinearGradient(
    colors: [
      AppColors.red,
      Color(0xCCCC0000), // red.withValues(alpha: 0.8)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SizedBox(
          width: width ?? 130.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Movie poster card
              Container(
                width: width ?? 130.w,
                height: height ?? 180.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Movie poster image with RepaintBoundary
                    RepaintBoundary(
                      child: IgnorePointer(
                        child: CommonImage(
                          imageSrc: imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: 12.r,
                          fill: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Badge at top right (if provided)
                    if (badge != null)
                      Positioned(
                        top: 0.h,
                        right: 0.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.r),
                              bottomLeft: Radius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (isBookmarked)
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
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Title below the image
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (date != null)
                      Text(
                        date!,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),

                    if (isRemindMe)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(30.r),
                          gradient: _remindMeGradient,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alarm,
                              color: AppColors.white,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Remind me',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
