import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/pop_up/common_pop_menu.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_icons.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Your Profile",
        isShowBackButton: false,
        titleFontSize: 24.sp,

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Get.to(() => NotificationScreen()),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) {
            return Column(
              spacing: 4.h,
              children: [
                SizedBox(
                  width: 110.w,
                  height: 110.h,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.editProfile,
                        arguments: {
                          "name": controller.profileModel.value?.name,
                          "email": controller.profileModel.value?.email,
                          "image": controller.profileModel.value?.image,
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3), // border thickness
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.buton,
                          width: 2, // border width
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100), // full circle
                        child: Image.network(
                          "${ApiEndPoint.domain}${controller.profileModel.value?.image}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.defaultProfile,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.editProfile,
                      arguments: {
                        "name": controller.profileModel.value?.name,
                        "email": controller.profileModel.value?.email,
                        "image": controller.profileModel.value?.image,
                      },
                    );
                  },
                  child: CommonText(
                    text: controller.profileModel.value?.name ?? "No Data",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                  ),
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
                Obx(() {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
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
                                text:
                                    controller
                                            .profileModel
                                            .value
                                            ?.isSubscribed ==
                                        true
                                    ? "Subscription Successful"
                                    : "Subscribe",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.background,
                              ),
                              4.height,
                              CommonText(
                                text:
                                    controller
                                            .profileModel
                                            .value
                                            ?.isSubscribed ==
                                        true
                                    ? "Welcome to the dark side of storytelling. Enter. Watch. Stay"
                                    : "Join membership now for unlimited adfree access",
                                fontSize: 12.sp,

                                fontWeight: FontWeight.w400,
                                color: AppColors.background.withValues(
                                  alpha: 0.8,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        12.width,
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
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
                              text:
                                  controller.profileModel.value?.isSubscribed ==
                                      true
                                  ? "\$${controller.profileModel.value?.subscription?.price ?? 0.0} /month"
                                  : "Subscribe Now",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

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
                        text: "Settings Account",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.background,
                      ),

                      ProfileRow(
                        onTap: () {
                          if (controller.profileModel.value?.isSubscribed ==
                              false) {
                            Utils.messageSnackBar(
                              context,
                              "Subscription Required",
                              "Please subscribe to the app to download offline",
                            );
                          } else {
                            Get.toNamed(AppRoutes.downloadSeason);
                          }
                        },
                        title: "Offline Download",
                        leadPath: AppIcons.icOfflineDownload,
                      ),
                      // ProfileRow(title: "Language", leadPath: AppImages.icLanguage),
                      ProfileRow(
                        onTap: () {
                          Get.toNamed(AppRoutes.faqs);
                        },
                        title: "FAQs",
                        leadPath: AppIcons.icFaq,
                      ),
                      CommonText(
                        text: "More Setting",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.background,
                      ),
                      ProfileRow(
                        title: "Feedback",
                        leadPath: AppIcons.icFeedback,
                      ),
                      ProfileRow(
                        onTap: () {
                          Get.toNamed(AppRoutes.setting);
                        },
                        title: "Settings",
                        leadPath: AppIcons.icSettings,
                      ),
                      ProfileRow(
                        onTap: () {
                          logOutPopUp();
                        },
                        leadColor: AppColors.red,
                        title: "Log out",
                        leadPath: AppIcons.icLogout,
                      ),
                      48.height,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String? title;
  final String? leadPath;
  final Color? leadColor;
  final VoidCallback? onTap;
  const ProfileRow({
    super.key,
    this.title,
    this.leadPath,
    this.leadColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: 12.w,
        children: [
          CommonImage(
            imageSrc: leadPath ?? AppImages.add,
            width: 24.w,
            height: 24.h,
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
      ),
    );
  }
}
