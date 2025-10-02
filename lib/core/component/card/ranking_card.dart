import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';

class RankingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int ranking;
  final bool isHot;
  final VoidCallback? onTap;

  const RankingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ranking,
    this.isHot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Row(
          children: [
            // Ranking number
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: _getRankingColor(),
                borderRadius: BorderRadius.circular(8.r),
                gradient: _getRankingGradient(),
              ),
              child: Center(
                child: Text(
                  ranking.toString(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Movie thumbnail
            Container(
              width: 80.w,
              height: 120.h,
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

            SizedBox(width: 16.w),

            // Movie details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Hot indicator (fire icon)
            if (isHot)
              Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 24.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankingColor() {
    switch (ranking) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.red;
    }
  }

  LinearGradient? _getRankingGradient() {
    switch (ranking) {
      case 1:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
        );
      case 3:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.red, AppColors.red2],
        );
    }
  }
}