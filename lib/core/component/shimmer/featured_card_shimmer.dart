import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';

/// Shimmer for featured/banner cards
class FeaturedCardShimmer extends StatelessWidget {
  const FeaturedCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        width: double.infinity,
        height: 220.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            // Main image placeholder
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            // Bottom info section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 180.w,
                      height: 18.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 8.h),
                    ShimmerBox(
                      width: 120.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for ranking/top chart cards
class RankingCardShimmer extends StatelessWidget {
  const RankingCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        child: Row(
          children: [
            // Rank number
            ShimmerBox(
              width: 40.w,
              height: 50.h,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(width: 8.w),
            // Movie card
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: 120.w,
                  height: 160.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(height: 8.h),
                ShimmerBox(
                  width: 120.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for horizontal ranking list
class HorizontalRankingShimmer extends StatelessWidget {
  const HorizontalRankingShimmer({
    super.key,
    this.itemCount = 5,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const RankingCardShimmer();
        },
      ),
    );
  }
}
