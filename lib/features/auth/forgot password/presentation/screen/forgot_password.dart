import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/button/common_button_pro.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';

import '../controller/forget_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ForgetPasswordController>(
      builder: (controller) => Scaffold(
        /// App Bar Section
        appBar: CommonAppBar(
          title: "",
          // actions: [
          //   TextButton(
          //     onPressed: () {},
          //     child: CommonText(text: "Skip", color: AppColors.background),
          //   ),
          // ],
        ),

        /// body section
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Log In Instruction here
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),

                  // decoration: BoxDecoration(
                  //   border: Border.all(color: AppColors.background),
                  //   borderRadius: BorderRadius.circular(30.w),
                  //   color: AppColors.white.withValues(alpha: 0.3),
                  // ),
                  child: Column(
                    spacing: 8.h,
                    children: [
                      CommonImage(
                        width: 120.w,
                        height: 120.h,
                        imageSrc: AppImages.logo,
                      ),
                      CommonText(
                        text: "Forgot Your Password?",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                      CommonText(
                        maxLines: 3,
                        textAlign: TextAlign.center,

                        text:
                            "No worries! Enter the email address associated with your account, and we’ll send you instructions to reset your password.",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
                50.height,

                CommonTextField(
                  controller: controller.emailController,
                  borderColor: AppColors.background,
                  textColor: AppColors.background,
                  hintTextColor: AppColors.background,
                  borderRadius: 30.w,
                  fillColor: AppColors.background.withValues(alpha: 0.3),
                  hintText: AppString.email,
                  validator: OtherHelper.passwordValidator,
                ),
                24.height,

                ///  Submit Button here
                Obx(() {
                  return controller.isLoadingEmail.value
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : CommonButtonPro(
                          onTap: () {
                            controller.forgotPasswordRepo();
                          },
                          text: "Get Verification Code",
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
