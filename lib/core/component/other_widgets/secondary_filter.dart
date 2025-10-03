import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class SecondaryFilter extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const SecondaryFilter({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red : AppColors.transparent,
                gradient: isSelected
                    ? LinearGradient(
                        colors: [AppColors.red2, AppColors.red],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      )
                    : null,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
