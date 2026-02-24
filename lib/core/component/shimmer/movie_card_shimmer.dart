import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';

/// Shimmer effect for movie cards in grid view
class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie thumbnail
          ShimmerBox(
            width: double.infinity,
            height: 180.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 8.h),
          // Movie title
          ShimmerBox(
            width: double.infinity,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 6.h),
          // Movie subtitle/genre
          ShimmerBox(
            width: 80.w,
            height: 12.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for movies grid
class MoviesGridShimmer extends StatelessWidget {
  const MoviesGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.50,
        ),
        itemBuilder: (context, index) {
          return const MovieCardShimmer();
        },
      ),
    );
  }
}
