import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/button/common_button_pro.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:get/get.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts Here
      appBar: CommonAppBar(
        title: "",
        actions: [
          TextButton(
            onPressed: () {},
            child: CommonText(text: "Skip", color: AppColors.background),
          ),
        ],
      ),

      /// Body Section Starts Here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: controller.signUpFormKey,
              child: Column(
                children: [
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  24.height,

                  /// Log In Instruction here
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 18.h),

                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.background),
                      borderRadius: BorderRadius.circular(30.w),
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      children: [
                        CommonText(
                          text: "Logo",
                          fontSize: 64.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                        ),
                        CommonText(
                          text: "Create Your Account",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                        ),
                        CommonText(
                          text: "Let's dive in into your occount",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                        ),
                      ],
                    ),
                  ),
                  24.height,

                  CommonTextField(
                    controller: controller.emailController,
                    borderColor: AppColors.background,
                    borderRadius: 30.w,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    hintText: AppString.fullName,
                    validator: OtherHelper.emailValidator,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.emailController,
                    borderColor: AppColors.background,
                    borderRadius: 30.w,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    hintText: AppString.email,
                    validator: OtherHelper.emailValidator,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.emailController,
                    borderColor: AppColors.background,
                    borderRadius: 30.w,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    hintText: AppString.password,
                    validator: OtherHelper.emailValidator,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.passwordController,
                    borderColor: AppColors.background,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    borderRadius: 30.w,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    isPassword: true,
                    hintText: AppString.newPassword,
                    validator: OtherHelper.passwordValidator,
                  ),
                  24.height,
                  CommonButtonPro(
                    text: "Sign Up",
                    onTap: () {
                      Get.toNamed(AppRoutes.verifyEmail);
                    },
                  ),

                  24.height,
                  CommonText(
                    text: "Or",
                    fontSize: 18.sp,
                    color: AppColors.background,
                  ),
                  24.height,
                  Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: AppColors.background,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          child: Center(
                            child: CommonImage(
                              imageSrc: AppImages.google,
                              width: 24.w,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: AppColors.blue,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          child: Center(
                            child: CommonImage(
                              imageSrc: AppImages.facebook,
                              width: 24.w,
                              imageColor: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
