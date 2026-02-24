import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    this.onSearchChanged,
    this.controller,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller?.text.isNotEmpty ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white200.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: TextField(
          controller: widget.controller,
          style: TextStyle(color: AppColors.white),
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.white.withValues(alpha: 0.6),
              size: 20.sp,
            ),
            suffixIcon: hasText
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.white.withValues(alpha: 0.6),
                      size: 20.sp,
                    ),
                    onPressed: () {
                      widget.controller?.clear();
                      widget.onClear?.call();
                      widget.onSearchChanged?.call('');
                    },
                  )
                : null,
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
