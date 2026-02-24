import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/constants/app_colors.dart';

class AdOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;
  final RxBool canClose;

  const AdOverlayWidget({
    super.key,
    required this.onClose,
    required this.canClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .95),
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Ad placeholder content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 300.w,
                    height: 400.h,
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: .15),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 72.w,
                          color: AppColors.white.withValues(alpha: .5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Advertisement',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: .7),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your ad content here',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: .4),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Obx(
                    () => canClose.value
                        ? const SizedBox.shrink()
                        : Text(
                            'Ad will close shortly...',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: .5),
                              fontSize: 12.sp,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Close button (top-right, visible only when canClose is true)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: canClose.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: canClose.value
                      ? GestureDetector(
                          onTap: onClose,
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: .2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.white,
                              size: 20.w,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
