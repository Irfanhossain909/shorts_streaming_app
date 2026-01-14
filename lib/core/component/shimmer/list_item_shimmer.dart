import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';

/// Shimmer for horizontal movie list
class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({
    super.key,
    this.itemCount = 5,
    this.itemWidth = 140,
    this.itemHeight = 200,
  });

  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight.h,
      child: ShimmerBase(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              width: itemWidth.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: itemWidth.w,
                    height: (itemHeight - 40).h,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(height: 8.h),
                  ShimmerBox(
                    width: itemWidth.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(height: 6.h),
                  ShimmerBox(
                    width: (itemWidth * 0.6).w,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Shimmer for notification/message list items
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Avatar
            ShimmerCircle(size: 50.w),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: double.infinity,
                    height: 16.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(height: 8.h),
                  ShimmerBox(
                    width: 200.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(height: 6.h),
                  ShimmerBox(
                    width: 100.w,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for vertical list
class VerticalListShimmer extends StatelessWidget {
  const VerticalListShimmer({
    super.key,
    this.itemCount = 8,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ListItemShimmer();
      },
    );
  }
}
