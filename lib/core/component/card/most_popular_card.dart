// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';

class MostPopularCard extends StatelessWidget {
  final String imageUrl;
  final int ranking;
  final VoidCallback? onTap;

  const MostPopularCard({
    super.key,
    required this.imageUrl,
    required this.ranking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
        child: Stack(
          children: [
            Container(
              width: 110.w,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CommonImage(
                  imageSrc: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fill: BoxFit.cover,
                ),
              ),
            ),
            // Badge at top right (if provided)
            Positioned(
              bottom: 0.h,
              right: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: 12.sp,
                      color: AppColors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '100K',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              left: -4.w,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    ranking.toString(),
                    style: TextStyle(
                      fontSize: 100.sp,
                      fontWeight: FontWeight.w900,

                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth =
                            1 // Border এর width
                        ..color = AppColors.white, // Border color white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
