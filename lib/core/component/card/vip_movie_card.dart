import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';

class VipMovieCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? badge;
  final String? ranking;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isLarge;

  const VipMovieCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badge,
    this.ranking,
    this.onTap,
    this.width,
    this.height,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 220,
        margin: EdgeInsets.only(right: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie poster with overlay
                  Container(
                    width: width ?? 80,
                    height: height ?? 130,
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

                        // Gradient overlay for better text readability
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.transparent,
                                AppColors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),

                        // VIP Badge at top left
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
                                  topRight: Radius.circular(6.r),
                                  bottomLeft: Radius.circular(6.r),
                                ),
                                gradient: LinearGradient(
                                  colors: [AppColors.red2, AppColors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        // Ranking number at bottom left
                        if (ranking != null)
                          Positioned(
                            bottom: 12.h,
                            left: 8.w,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  ranking!,
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900,

                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth =
                                          1 // Border এর width
                                      ..color =
                                          AppColors.white, // Border color white
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Title and subtitle overlay at bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  40.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
