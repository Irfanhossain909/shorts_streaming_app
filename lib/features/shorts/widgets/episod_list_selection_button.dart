import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';

class EpisodeListSelectButton extends StatelessWidget {
  final bool isSelected;
  final String? tag;
  const EpisodeListSelectButton({super.key, this.isSelected = false, this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.red2
              : AppColors.white.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(24.r),
        color: isSelected ? AppColors.red : AppColors.transparent,
      ),
      child: CommonText(
        text: tag ?? "1-25",
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: isSelected
            ? AppColors.white
            : AppColors.background.withValues(alpha: 0.6),
      ),
    );
  }
}

