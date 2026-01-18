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
import 'package:testemu/features/auth/sign%20up/presentation/widget/already_accunt_rich_text.dart';
import '../controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      /// App Bar
      appBar: const CommonAppBar(isShowBackButton: false, title: ""),

      bottomNavigationBar: const SafeArea(child: AlreadyAccountRichText()),

      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          overscroll: false, // ✅ IMPORTANT FIX
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GetBuilder<SignUpController>(
            builder: (controller) {
              return Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    24.height,

                    /// Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Column(
                        children: [
                          CommonImage(
                            width: 120.w,
                            height: 120.h,
                            imageSrc: AppImages.logo,
                          ),
                          CommonText(
                            text: "Create Your Account",
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

                    /// Full name
                    CommonTextField(
                      controller: controller.nameController,
                      borderColor: AppColors.background,
                      borderRadius: 30.w,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      fillColor: AppColors.background.withValues(alpha: 0.3),
                      hintText: AppString.fullName,
                      keyboardType: TextInputType.name,
                    ),

                    20.height,

                    /// Email
                    CommonTextField(
                      controller: controller.emailController,
                      borderColor: AppColors.background,
                      borderRadius: 30.w,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      fillColor: AppColors.background.withValues(alpha: 0.3),
                      hintText: AppString.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    20.height,

                    /// Password
                    CommonTextField(
                      controller: controller.passwordController,
                      borderColor: AppColors.background,
                      borderRadius: 30.w,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      isPassword: true,
                      fillColor: AppColors.background.withValues(alpha: 0.3),
                      hintText: AppString.password,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    20.height,

                    /// Confirm password
                    CommonTextField(
                      controller: controller.confirmPasswordController,
                      borderColor: AppColors.background,
                      textColor: AppColors.background,
                      hintTextColor: AppColors.background,
                      borderRadius: 30.w,
                      fillColor: AppColors.background.withValues(alpha: 0.3),
                      isPassword: true,
                      hintText: AppString.newPassword,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    24.height,

                    /// Sign Up Button / Loader
                    Obx(() {
                      return controller.isLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : CommonButtonPro(
                              text: "Sign Up",
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).unfocus(); // ✅ safe keyboard close
                                controller.signUpUser();
                              },
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
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
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
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:testemu/core/component/appbar/common_app_bar.dart';
// import 'package:testemu/core/component/button/common_button_pro.dart';
// import 'package:testemu/core/component/image/common_image.dart';
// import 'package:testemu/core/component/text/common_text.dart';
// import 'package:testemu/core/component/text_field/common_text_field.dart';
// import 'package:testemu/core/constants/app_colors.dart';
// import 'package:testemu/core/constants/app_images.dart';
// import 'package:testemu/core/constants/app_string.dart';
// import 'package:testemu/core/utils/extensions/extension.dart';
// import 'package:testemu/features/auth/sign%20up/presentation/widget/already_accunt_rich_text.dart';

// import '../controller/sign_up_controller.dart';

// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signUpFormKey = GlobalKey<FormState>();
//     return Scaffold(
//       /// App Bar Section Starts Here
//       appBar: CommonAppBar(isShowBackButton: false, title: ""),
//       bottomNavigationBar: SafeArea(child: AlreadyAccountRichText()),

//       /// Body Section Starts Here
//       body: GetBuilder<SignUpController>(
//         builder: (controller) {
//           return SingleChildScrollView(
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Form(
//               key: signUpFormKey,
//               child: Column(
//                 children: [
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   24.height,

//                   /// Log In Instruction here
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 18.h),

//                     // decoration: BoxDecoration(
//                     //   border: Border.all(color: AppColors.background),
//                     //   borderRadius: BorderRadius.circular(30.w),
//                     //   color: AppColors.white.withValues(alpha: 0.3),
//                     // ),
//                     child: Column(
//                       children: [
//                         CommonImage(
//                           width: 120.w,
//                           height: 120.h,
//                           imageSrc: AppImages.logo,
//                         ),
//                         CommonText(
//                           text: "Create Your Account",
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.background,
//                         ),
//                         CommonText(
//                           text: "Let's dive in into your occount",
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.background,
//                         ),
//                       ],
//                     ),
//                   ),
//                   24.height,

//                   CommonTextField(
//                     controller: controller.nameController,
//                     borderColor: AppColors.background,
//                     borderRadius: 30.w,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     hintText: AppString.fullName,
//                     keyboardType: TextInputType.name,
//                   ),
//                   20.height,
//                   CommonTextField(
//                     controller: controller.emailController,
//                     borderColor: AppColors.background,
//                     borderRadius: 30.w,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     hintText: AppString.email,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   20.height,
//                   CommonTextField(
//                     controller: controller.passwordController,
//                     borderColor: AppColors.background,
//                     borderRadius: 30.w,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     isPassword: true,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     hintText: AppString.password,
//                     keyboardType: TextInputType.visiblePassword,
//                   ),
//                   20.height,
//                   CommonTextField(
//                     controller: controller.confirmPasswordController,
//                     borderColor: AppColors.background,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     borderRadius: 30.w,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     isPassword: true,
//                     hintText: AppString.newPassword,
//                     keyboardType: TextInputType.visiblePassword,
//                   ),
//                   24.height,
//                   Obx(() {
//                     return controller.isLoading.value
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                           )
//                         : CommonButtonPro(
//                             text: "Sign Up",
//                             onTap: () {
//                               controller.signUpUser();
//                             },
//                           );
//                   }),

//                   24.height,
//                   CommonText(
//                     text: "Or",
//                     fontSize: 18.sp,
//                     color: AppColors.background,
//                   ),
//                   24.height,
//                   Row(
//                     spacing: 12.w,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12.w),
//                             color: AppColors.background,
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 18.h),
//                           child: Center(
//                             child: CommonImage(
//                               imageSrc: AppImages.google,
//                               width: 24.w,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12.w),
//                             color: AppColors.blue,
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 18.h),
//                           child: Center(
//                             child: CommonImage(
//                               imageSrc: AppImages.facebook,
//                               width: 24.w,
//                               imageColor: AppColors.background,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
