import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';

class EpisodSelectBtn extends StatelessWidget {
  final bool isRunning;
  final bool isAvilable;
  final bool isLock;
  final String? text;
  const EpisodSelectBtn({
    super.key,
    this.text,
    this.isRunning = false,
    this.isAvilable = false,
    this.isLock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isRunning
            ? Container(
                decoration: BoxDecoration(
                  color: AppColors.buttonColor2.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.waves,
                  size: 18.w,
                  color: AppColors.activeTrackColor,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: isLock
                      ? AppColors.buttonColor2.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: CommonText(
                  text: text ?? "no text",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isLock ? AppColors.white : AppColors.white,
                ),
              ),
        isLock
            ? Positioned(
                top: 6.w,
                right: 4.w,
                child: Icon(
                  Icons.lock_outline,
                  size: 14.w,
                  color: AppColors.white,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
