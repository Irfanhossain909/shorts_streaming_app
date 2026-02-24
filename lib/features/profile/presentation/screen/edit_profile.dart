import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:get/get.dart';
import 'package:testemu/features/profile/presentation/controller/edit_profile_controller.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import '../widgets/edit_profile_all_filed.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) {
        return Scaffold(
          /// App Bar Sections Starts here
          appBar: CommonAppBar(title: "Edit Profile", titleFontSize: 24.sp),

          /// Body Sections Starts here
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              spacing: 10.h,
              children: [
                /// User Profile image here
                Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 85.sp,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                          child: controller.image != null
                              ? Image.file(
                                  File(controller.image!),
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.fill,
                                )
                              : controller.imageReceived != null
                              ? CommonImage(
                                  imageSrc:
                                      "${ApiEndPoint.domain}${controller.imageReceived}",
                                  height: 170,
                                  width: 170,
                                )
                              : const CommonImage(
                                  imageSrc: AppImages.defaultProfile,
                                  height: 170,
                                  width: 170,
                                ),
                        ),
                      ),
                    ),
                    ),

                    /// image change icon here
                    Positioned(
                      bottom: 0,
                      left: Get.width * 0.53,
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                            (states) => AppColors.red,
                          ),
                        ),
                        onPressed: controller.getProfileImage,
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                20.height,

                /// user all information filed here
                EditProfileAllFiled(controller: controller),
                30.height,

                // / Submit Button here
                Obx(
                  () => CommonButton(
                    titleText: AppString.saveAndChanges,
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      controller.editProfile();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
