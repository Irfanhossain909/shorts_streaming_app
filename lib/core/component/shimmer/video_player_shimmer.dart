import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';
import 'package:testemu/core/constants/app_colors.dart';

/// Shimmer loading for video player (shorts/reels)
class VideoPlayerShimmer extends StatelessWidget {
  const VideoPlayerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main shimmer background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: ShimmerBase(
            child: Container(
              color: Colors.grey[900],
            ),
          ),
        ),

        // Loading animation in center
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated loading icon
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.red2.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ShimmerBase(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Loading video...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom gradient with shimmer info
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 400.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.5),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 110.h, left: 20.w, right: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBase(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(
                          width: 200.w,
                          height: 18.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 8.h),
                        ShimmerBox(
                          width: 280.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 6.h),
                        ShimmerBox(
                          width: 250.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right side action buttons shimmer
        Positioned(
          bottom: 146.h,
          right: 10.w,
          child: ShimmerBase(
            child: Column(
              spacing: 16.h,
              children: List.generate(
                5,
                (index) => ShimmerCircle(size: 48.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
