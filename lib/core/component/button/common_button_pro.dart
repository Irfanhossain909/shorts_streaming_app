import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';

class CommonButtonPro extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  const CommonButtonPro({super.key, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.background),
          borderRadius: BorderRadius.circular(30.w),
          color: AppColors.background.withValues(alpha: 0.3),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          spacing: 8.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text:text ?? "No Text",
              fontSize: 16.sp,
              color: AppColors.background,
            ),
            Icon(
              Icons.arrow_right_alt_rounded,
              color: AppColors.background,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
