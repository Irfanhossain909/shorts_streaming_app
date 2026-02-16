import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class NotificationShimmerCard extends StatelessWidget {
  const NotificationShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buton.withOpacity(0.4),
      highlightColor: AppColors.white.withOpacity(0.2),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.buton),
        ),
        child: Row(
          children: [
            /// Icon shimmer
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.buton,
                shape: BoxShape.circle,
              ),
            ),

            16.width,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title shimmer
                  Container(
                    height: 16.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.buton,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  8.height,

                  /// Subtitle shimmer
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.buton,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  6.height,

                  Container(
                    height: 14.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: AppColors.buton,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  10.height,

                  /// Time shimmer
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 8.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.buton,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
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
