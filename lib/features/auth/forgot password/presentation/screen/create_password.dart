import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/button/common_button_pro.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/controller/create_password_controller.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        //
      ),

      /// Body Section
      body: GetBuilder<CreatePasswordController>(
        init: CreatePasswordController(),
        builder: (controller) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false, // ✅ IMPORTANT FIX
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Log In Instruction
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),

                      child: Column(
                        spacing: 8.h,
                        children: [
                          CommonImage(
                            width: 120.w,
                            height: 120.h,
                            imageSrc: AppImages.logo,
                          ),
                          CommonText(
                            text: "Set Your New Password",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                          ),
                          CommonText(
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            text:
                                "Create a new password for your account. Make sure it’s strong and secure.",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.background,
                          ),
                        ],
                      ),
                    ),
                    44.height,

                    CommonTextField(
                      controller: controller.newPasswordController,
                      borderColor: AppColors.buton,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      borderRadius: 30.w,
                      fillColor: AppColors.buton,
                      hintText: AppString.password,
                      isPassword: true,
                      validator: OtherHelper.passwordValidator,
                    ),
                    16.height,
                    CommonTextField(
                      controller: controller.confirmPasswordController,
                      borderColor: AppColors.buton,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      borderRadius: 30.w,
                      fillColor: AppColors.buton,
                      hintText: AppString.newPassword,
                      isPassword: true,
                      validator: OtherHelper.passwordValidator,
                    ),
                    38.height,

                    /// Submit Button
                    Obx(() {
                      return controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : CommonButton(
                              onTap: () {
                                controller.createPassword();
                              },
                              titleText: "Save New Password",
                            );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomGrediantForAllScreen extends StatelessWidget {
  const CustomGrediantForAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF981C2C), // Deep
            Color(0xFF821826), // একটু হালকা
            Color(0xFF6B1521), // Dark
            Color(0xFF55111B), // একটু হালকা
            Color(0xFF3E0E16), // Darker
            Color(0xFF2D0A10), // Almost darkest
            Color.fromARGB(255, 15, 3, 5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
