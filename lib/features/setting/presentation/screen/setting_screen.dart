import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Settings", isCenterTitle: false),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "else",
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.background,
            ),
            ProfileRow(
              title: "Privacy Policy",
              leadPath: AppImages.icOfflineDownload,
            ),
            ProfileRow(
              onTap: () {
                Get.toNamed(AppRoutes.userAgreement);
              },
              title: "User Agreement",
              leadPath: AppImages.icLanguage,
            ),
            ProfileRow(
              onTap: () {
                Get.toNamed(AppRoutes.deleteAccount);
              },
              title: "Delete Account",
              leadPath: AppImages.icFaq,
            ),
          ],
        ),
      ),
    );
  }
}
