import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';

class ComingSoonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String releaseDate;
  final VoidCallback? onTap;
  final VoidCallback? onRemindMeTap;
  final double? width;
  final double? height;

  const ComingSoonCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.releaseDate,
    this.onTap,
    this.onRemindMeTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 140.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            Container(
              width: width ?? 140.w,
              height: height ?? 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Movie poster image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CommonImage(
                      imageSrc: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fill: BoxFit.cover,
                    ),
                  ),

                  // VIP Badge at top right
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'VIP',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            8.verticalSpace,

            // Title
            Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            2.verticalSpace,

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            2.verticalSpace,

            // Release date
            Text(
              releaseDate,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            8.verticalSpace,

            // Remind Me button
            GestureDetector(
              onTap: onRemindMeTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: LinearGradient(
                    colors: [AppColors.red2, AppColors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.alarm, color: AppColors.white, size: 14.sp),
                    4.horizontalSpace,
                    Text(
                      'Remind Me',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
