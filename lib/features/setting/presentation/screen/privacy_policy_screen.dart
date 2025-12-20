import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/other_widgets/common_loader.dart';
import 'package:testemu/core/component/screen/error_screen.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/setting/presentation/controller/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(
      init: PrivacyPolicyController.instance,
      builder: (controller) {
        if (controller.status == Status.loading) {
          return const CommonLoader(size: 60);
        }
        if (controller.status == Status.error) {
          return ErrorScreen(onTap: controller.getPrivacyPolicyRepo);
        }
        return Scaffold(
          appBar: CommonAppBar(title: "Privacy Policy"),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              spacing: 36.h,
              children: [
                70.height,
                CommonText(
                  text: "Privacy Policy",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.activeTrackColor,
                  ),
                ),
                Html(
                  data: controller.data.content,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(10.sp),
                      fontWeight: FontWeight.w400,
                      color: AppColors.activeTrackColor.withValues(alpha: 0.8),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    "h1": Style(
                      fontSize: FontSize(16.sp),
                      fontWeight: FontWeight.w700,
                      color: AppColors.activeTrackColor,
                    ),
                    "h2": Style(
                      fontSize: FontSize(14.sp),
                      fontWeight: FontWeight.w700,
                      color: AppColors.activeTrackColor,
                    ),
                    "h3": Style(
                      fontSize: FontSize(12.sp),
                      fontWeight: FontWeight.w600,
                      color: AppColors.activeTrackColor,
                    ),
                    "p": Style(
                      fontSize: FontSize(10.sp),
                      fontWeight: FontWeight.w400,
                      color: AppColors.activeTrackColor.withValues(alpha: 0.8),
                    ),
                    "li": Style(
                      fontSize: FontSize(10.sp),
                      fontWeight: FontWeight.w400,
                      color: AppColors.activeTrackColor.withValues(alpha: 0.8),
                    ),
                    "strong": Style(fontWeight: FontWeight.w700),
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
