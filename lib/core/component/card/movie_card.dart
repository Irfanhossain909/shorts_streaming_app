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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                        gradient: LinearGradient(
                          colors: [
                            AppColors.red,
                            AppColors.red.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
    );
  }
}
