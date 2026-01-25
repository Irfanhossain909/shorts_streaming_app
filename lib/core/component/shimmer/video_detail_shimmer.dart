import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';
import 'package:testemu/core/constants/app_colors.dart';

/// Shimmer effect for video detail screen
class VideoDetailShimmer extends StatelessWidget {
  const VideoDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.redGradient1,
            AppColors.redGradient2,
          ],
          stops: [0.8, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 80.h, left: 16.w, right: 16.w),
        child: SingleChildScrollView(
          child: ShimmerBase(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button shimmer
                ShimmerCircle(size: 40.w),
                SizedBox(height: 40.h),

                // Image and description row
                Row(
                  children: [
                    // Poster image shimmer
                    ShimmerBox(
                      width: 84.w,
                      height: 120.h,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    SizedBox(width: 10.w),
                    // Description shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: double.infinity,
                            height: 18.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          SizedBox(height: 8.h),
                          ShimmerBox(
                            width: 150.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          SizedBox(height: 12.h),
                          // Tags shimmer
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.w,
                            children: List.generate(
                              4,
                              (index) => ShimmerBox(
                                width: 60.w,
                                height: 24.h,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Introduction section
                ShimmerBox(
                  width: 120.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                ShimmerBox(
                  width: 250.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),

                SizedBox(height: 24.h),

                // Episode section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerBox(
                          width: 80.w,
                          height: 20.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(width: 10.w),
                        ShimmerBox(
                          width: 100.w,
                          height: 32.h,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ],
                    ),
                    ShimmerBox(
                      width: 80.w,
                      height: 16.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Episode buttons shimmer
                const EpisodeButtonsShimmer(),

                SizedBox(height: 20.h),

                // You could like section
                ShimmerBox(
                  width: 150.w,
                  height: 24.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 10.h),

                // Recommended videos shimmer
                const RecommendedVideosShimmer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for episode buttons
class EpisodeButtonsShimmer extends StatelessWidget {
  const EpisodeButtonsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            width: 70.w,
            margin: EdgeInsets.only(right: 8.w),
            child: ShimmerBox(
              width: 70.w,
              height: 40.h,
              borderRadius: BorderRadius.circular(8.r),
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for recommended videos
class RecommendedVideosShimmer extends StatelessWidget {
  const RecommendedVideosShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 140.w,
            margin: EdgeInsets.only(right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: 140.w,
                  height: 200.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(height: 8.h),
                ShimmerBox(
                  width: 140.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                ShimmerBox(
                  width: 100.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
