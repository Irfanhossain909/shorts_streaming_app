import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_icons.dart';
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
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(
              onTap: () {
                Get.toNamed(AppRoutes.privacyPolicy);
              },
              title: "Privacy Policy",
              leadPath: AppIcons.icOfflineDownload,
            ),
            ProfileRow(
              onTap: () {
                Get.toNamed(AppRoutes.userAgreement);
              },
              title: "User Agreement",
              leadPath: AppIcons.icLanguage,
            ),
            ProfileRow(
              onTap: () {
                Get.toNamed(AppRoutes.deleteAccount);
              },
              title: "Delete Account",
              leadPath: AppIcons.icFaq,
            ),
          ],
        ),
      ),
    );
  }
}
