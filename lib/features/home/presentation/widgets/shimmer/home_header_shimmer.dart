import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class HomeHeaderShimmer extends StatelessWidget {
  const HomeHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: AppColors.white.withOpacity(0.2),
        highlightColor: AppColors.white.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Big shimmer text
                  Container(
                    height: 28.h,
                    width: 180.w,
                    color: Colors.white,
                  ),
                  4.height,
                  // Smaller shimmer text
                  Container(
                    height: 16.h,
                    width: 140.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            // Notification Icon shimmer
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
