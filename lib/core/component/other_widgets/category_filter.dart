import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        addRepaintBoundaries: true,
        addAutomaticKeepAlives: false,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              category.trim().toLowerCase() ==
              selectedCategory.trim().toLowerCase();

          // Extract to separate widget to isolate rebuilds
          return _CategoryChip(
            key: ValueKey(category),
            category: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

// Separate widget to isolate rebuilds and enable const optimizations
class _CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  // Cache gradient
  static const _selectedGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.red2, AppColors.red],
  );

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary to isolate repaints
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : AppColors.transparent,
            gradient: isSelected ? _selectedGradient : null,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.red
                  : AppColors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
