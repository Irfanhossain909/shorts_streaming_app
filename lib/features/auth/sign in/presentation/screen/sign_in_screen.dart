import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/auth/sign%20in/presentation/widgets/do_not_account.dart';
import '../controller/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        actions: [
          TextButton(
            onPressed: () {},
            child: CommonText(text: "Skip", color: AppColors.background),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(child: DoNotHaveAccount()),

      /// Body Sections Starts here
      body: GetBuilder<SignInController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: controller.formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          text: "Let's Get Started!",
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
                    hintText: AppString.email,
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
                    hintText: AppString.password,
                    validator: OtherHelper.passwordValidator,
                  ),

                  /// Forget Password Button here
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                      child: const CommonText(
                        text: AppString.forgotThePassword,
                        top: 10,
                        bottom: 30,
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  CommonButtonPro(
                    onTap: () {
                      Get.toNamed(AppRoutes.navigation);
                    },
                    text: "Sign In",
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
