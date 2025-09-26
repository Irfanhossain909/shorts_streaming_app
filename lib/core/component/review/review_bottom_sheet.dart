import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/extensions/extension.dart';

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({super.key});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (selectedRating == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    if (reviewController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write your review',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    // Submit review logic here
    Get.back();
    Get.snackbar(
      'Success',
      'Thank you for your feedback!',
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textFiledColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          20.height,

          // Title
          CommonText(
            text: "Give Your Feedback",
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),

          24.height,

          // Star Rating
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Icon(
                    Icons.star,
                    size: 48.sp,
                    color: index < selectedRating
                        ? AppColors.blue500
                        : AppColors.textFiledColor.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ),

          24.height,

          // Review Label
          CommonText(
            text: "Review",
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),

          12.height,

          // Review Text Field
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textFiledColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              controller: reviewController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Type Your Review",
                hintStyle: TextStyle(
                  color: AppColors.textFiledColor.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
          ),

          24.height,

          // Submit Button
          CommonButton(titleText: "Submit", onTap: _submitReview),

          // Add bottom padding for safe area
          MediaQuery.of(context).viewInsets.bottom > 0
              ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
              : 20.height,
        ],
      ),
    );
  }
}

// Helper function to show the bottom sheet
void showReviewBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ReviewBottomSheet(),
  );
}
