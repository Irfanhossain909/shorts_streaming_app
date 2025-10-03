import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String? title;
  final List<String>? subFilters;
  final String? selectedSubFilter;
  final Function(String)? onSubFilterSelected;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    this.title,
    this.subFilters,
    this.selectedSubFilter,
    this.onSubFilterSelected,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (onSeeAllTap != null)
                GestureDetector(
                  onTap: onSeeAllTap,
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),

          // Sub filters (Daily/Weekly for VIP section)
          if (subFilters != null && subFilters!.isNotEmpty) ...[
            12.verticalSpace,
            SizedBox(
              height: 32.h, // Fixed height to prevent wrapping
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...subFilters!.map((filter) {
                      final isSelected = filter == selectedSubFilter;
                      return GestureDetector(
                        onTap: () => onSubFilterSelected?.call(filter),
                        child: Container(
                          margin: EdgeInsets.only(right: 16.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.red
                                : AppColors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [AppColors.red2, AppColors.red],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.red
                                  : AppColors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 20.w), // Right padding
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
