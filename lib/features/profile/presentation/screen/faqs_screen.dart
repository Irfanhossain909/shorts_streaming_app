import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/other_widgets/common_loader.dart';
import 'package:testemu/core/component/screen/error_screen.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/features/profile/presentation/controller/faqs_controller.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqsController>(
      init: FaqsController.instance,
      builder: (controller) {
        if (controller.status == Status.loading) {
          return const CommonLoader(size: 60);
        }
        if (controller.status == Status.error) {
          return ErrorScreen(onTap: controller.getFaqsRepo);
        }
        return Scaffold(
          appBar: CommonAppBar(title: "FAQs"),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 32.r, left: 16.r, right: 16.r),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.faqs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: controller.faqs[index].question ?? '',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.activeTrackColor,
                      ),
                      SizedBox(height: 18.h),
                      CommonText(
                        text: controller.faqs[index].answer ?? '',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.activeTrackColor.withValues(
                          alpha: 0.8,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Divider(
                        color: AppColors.activeTrackColor.withValues(
                          alpha: 0.2,
                        ),
                        height: 1.h,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
