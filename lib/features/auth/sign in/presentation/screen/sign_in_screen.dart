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
  SignInScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: const CommonAppBar(
        isShowBackButton: false,
        title: "",
      ),

      bottomNavigationBar: const SafeArea(
        child: DoNotHaveAccount(),
      ),

      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          overscroll: false, // ✅ IMPORTANT FIX
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: GetBuilder<SignInController>(
            builder: (controller) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    24.height,

                    /// Logo + Title
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Column(
                        children: [
                          CommonImage(
                            width: 120.w,
                            height: 120.h,
                            imageSrc: AppImages.appLogoSvg,
                          ),
                          CommonText(
                            text: "Let's Get Started!",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                          CommonText(
                            text: "Let's dive in into your account",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                        ],
                      ),
                    ),

                    24.height,

                    /// Email
                    CommonTextField(
                      controller: controller.emailController,
                      borderColor: AppColors.background,
                      borderRadius: 30.w,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      fillColor:
                          AppColors.background.withValues(alpha: 0.3),
                      hintText: AppString.email,
                      validator: OtherHelper.emailValidator,
                    ),

                    20.height,

                    /// Password
                    CommonTextField(
                      controller: controller.passwordController,
                      borderColor: AppColors.background,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      borderRadius: 30.w,
                      fillColor:
                          AppColors.background.withValues(alpha: 0.3),
                      isPassword: true,
                      hintText: AppString.password,
                      validator: OtherHelper.passwordValidator,
                    ),

                    /// Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () =>
                            Get.toNamed(AppRoutes.forgotPassword),
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

                    /// Sign In Button / Loader
                    Obx(() {
                      return controller.isLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : CommonButtonPro(
                              onTap: () {
                                FocusScope.of(context).unfocus(); // ✅ keyboard close safe
                                controller.signInUser(
                                  formKey: _formKey,
                                );
                              },
                              text: "Sign In",
                            );
                    }),

                    24.height,

                    CommonText(
                      text: "Or",
                      fontSize: 18.sp,
                      color: AppColors.background,
                    ),

                    24.height,

                    /// Social buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 18.h),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(12.w),
                              color: AppColors.background,
                            ),
                            child: Center(
                              child: CommonImage(
                                imageSrc: AppImages.google,
                                width: 24.w,
                              ),
                            ),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 18.h),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(12.w),
                              color: AppColors.blue,
                            ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}


