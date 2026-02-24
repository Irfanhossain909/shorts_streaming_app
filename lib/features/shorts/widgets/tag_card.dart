import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';

class TagCard extends StatelessWidget {
  final String? tag;
  const TagCard({super.key, this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.black.withValues(alpha: 0.6),
      ),
      child: CommonText(
        text: tag ?? "No Text",
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.background,
      ),
    );
  }
}

