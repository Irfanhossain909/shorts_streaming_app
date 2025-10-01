import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Your Profile",
        isCenterTitle: false,
        isShowBackButton: false,
        titleFontSize: 24.sp,

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background.withValues(alpha: 0.2),
              ),
              padding: EdgeInsets.all(4.w),
              child: Stack(
                children: [
                  Icon(Icons.notifications, color: AppColors.background),
                  Positioned(
                    right: 5.w,
                    top: 4.w,
                    child: Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 4.h,
          children: [
            SizedBox(
              width: 110.w,
              height: 110.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50), // width/2 or height/2
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2025/02/05/08/07/man-9383629_640.jpg",
                  fit: BoxFit.cover, // image circular ভেতরে ঠিকমত দেখানোর জন্য
                ),
              ),
            ),
            CommonText(
              text: "Designjot",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.background,
            ),
            Row(
              spacing: 4.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: "UID: 143398274",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.background.withValues(alpha: 0.6),
                ),
                Icon(
                  Icons.copy,
                  size: 12.sp,
                  color: AppColors.background.withValues(alpha: 0.6),
                ),
              ],
            ),
            // Subscription Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.7),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: "Subscribe",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                        ),
                        4.height,
                        CommonText(
                          text:
                              "Join membership now for unlimited adfree access",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.background.withValues(alpha: 0.8),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  12.width,
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.subscription);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.red.withValues(alpha: 0.8),
                                AppColors.red.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CommonText(
                            text: "\$99.00/Week",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                      4.height,
                      CommonText(
                        text: r"Renew at $ 199.00",
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background.withValues(alpha: 0.8),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(16.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                spacing: 16.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Account Settings",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.background,
                  ),

                  ProfileRow(
                    title: "Offline Download",
                    leadPath: AppImages.icOfflineDownload,
                  ),
                  ProfileRow(title: "Language", leadPath: AppImages.icLanguage),
                  ProfileRow(title: "FAQs", leadPath: AppImages.icFaq),
                  CommonText(
                    text: "Account Settings",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.background,
                  ),
                  ProfileRow(title: "Feedback", leadPath: AppImages.icFeedback),
                  ProfileRow(title: "Settings", leadPath: AppImages.icSetting),
                  ProfileRow(
                    leadColor: AppColors.red,
                    title: "Log out",
                    leadPath: AppImages.icLogout,
                  ),
                  48.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String? title;
  final String? leadPath;
  final Color? leadColor;
  const ProfileRow({super.key, this.title, this.leadPath, this.leadColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        CommonImage(
          imageSrc: leadPath ?? AppImages.add,
          width: 20.w,
          height: 20.h,
          imageColor: leadColor ?? AppColors.background,
        ),

        CommonText(
          text: title ?? "no title",
          fontSize: 18.sp,
          color: AppColors.background,
          fontWeight: FontWeight.w500,
        ),

        Spacer(),
        Icon(
          Icons.arrow_forward_ios_outlined,
          size: 18.w,
          color: AppColors.background,
        ),
      ],
    );
  }
}
