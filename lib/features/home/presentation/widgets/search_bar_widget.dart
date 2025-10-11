import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onSearchChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.onSearchChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white200.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(color: AppColors.white),
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.white.withValues(alpha: 0.6),
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }
}