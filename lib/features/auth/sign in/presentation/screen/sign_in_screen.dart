import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';
import 'package:testemu/features/auth/sign%20in/presentation/widgets/do_not_account.dart';

import '../controller/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: CustomGrediantForAllScreen(),
        title: CommonImage(width: 135.w, imageSrc: AppImages.appLogoSvg),
        toolbarHeight: 128.h,
      ),

      // appBar: const CommonAppBar(isShowBackButton: false, title: ""),
      bottomNavigationBar: const SafeArea(child: DoNotHaveAccount()),

      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          overscroll: false, // ✅ IMPORTANT FIX
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GetBuilder<SignInController>(
            builder: (controller) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.h,
                      child: Obx(() {
                        if (controller.isLoadingSlider.value) {
                          return Column(
                            children: [
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
                          );
                        }
                        if (controller
                                .loginSliderData
                                .value
                                ?.data
                                ?.images
                                ?.isEmpty ??
                            true) {
                          return const Center(child: Text("No Data"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller
                              .loginSliderData
                              .value
                              ?.data
                              ?.images
                              ?.length,
                          itemBuilder: (context, index) {
                            final image = controller
                                .loginSliderData
                                .value
                                ?.data
                                ?.images?[index];

                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),

                                child: CommonImage(
                                  height: 200.h,
                                  width: 110.w,
                                  fill: BoxFit.cover,
                                  highQuality: true,
                                  imageSrc: OtherHelper.getImageUrl(
                                    image,
                                    // defaultAsset: AppImages.m4,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    48.height,

                    // /// Email
                    CommonTextField(
                      controller: controller.emailController,
                      borderColor: AppColors.buton,
                      borderRadius: 30.w,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      fillColor: AppColors.buton,
                      hintText: AppString.email,
                      validator: OtherHelper.emailValidator,
                    ),

                    20.height,

                    /// Password
                    CommonTextField(
                      controller: controller.passwordController,
                      borderColor: AppColors.buton,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      borderRadius: 30.w,
                      fillColor: AppColors.buton,
                      isPassword: true,
                      hintText: AppString.password,
                      // validator: OtherHelper.passwordValidator,
                    ),

                    /// Forgot password
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

                    /// Sign In Button / Loader
                    Obx(() {
                      return controller.isLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : CommonButton(
                              titleText: "Sign In",
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).unfocus(); // ✅ keyboard close safe
                                controller.signInUser(formKey: _formKey);
                              },
                            );
                    }),

                    18.height,

                    CommonText(
                      text: "Or",
                      fontSize: 18.sp,
                      color: AppColors.background,
                    ),

                    18.height,

                    /// Social buttons
                    Obx(() {
                      return controller.isGoogleLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : Row(
                              spacing: 12.w,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.loginWithGoogle();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 18.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.w,
                                        ),
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
                                ),
                                // 12.width,
                                // if (controller.platformType.value != "android")
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.loginWithApple();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 18.h,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.background,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.w,
                                        ),
                                        color: AppColors.black,
                                      ),
                                      child: Center(
                                        child: CommonImage(
                                          imageSrc: AppImages.apple,
                                          width: 24.w,
                                          imageColor: AppColors.background,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }),

                    24.height,

                    /// Continue as Guest
                    GestureDetector(
                      onTap: () => controller.continueAsGuest(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            text: "Continue as ",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.background.withValues(alpha: 0.6),
                          ),
                          CommonText(
                            text: "Guest",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12.sp,
                            color: AppColors.background,
                          ),
                        ],
                      ),
                    ),

                    24.height,
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
