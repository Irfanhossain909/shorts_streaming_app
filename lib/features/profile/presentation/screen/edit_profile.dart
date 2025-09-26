import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../widgets/edit_profile_all_filed.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          /// App Bar Sections Starts here
          appBar: AppBar(
            centerTitle: true,
            title: const CommonText(
              text: AppString.profile,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          /// Body Sections Starts here
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  /// User Profile image here
                  Stack(
                    children: [
                      Center(
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
                                : const CommonImage(
                                    imageSrc: AppImages.profile,
                                    height: 170,
                                    width: 170,
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
                              (states) => Colors.black,
                            ),
                          ),
                          onPressed: controller.getProfileImage,
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  /// user all information filed here
                  EditProfileAllFiled(controller: controller),
                  30.height,

                  /// Submit Button here
                  CommonButton(
                    titleText: AppString.saveAndChanges,
                    isLoading: controller.isLoading,
                    onTap: controller.editProfileRepo,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
