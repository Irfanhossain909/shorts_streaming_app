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
import '../controller/forget_password_controller.dart';

class CreatePassword extends StatelessWidget {
  CreatePassword({super.key});

  final formKey = GlobalKey<FormState>();

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

      /// Body Section
      body: GetBuilder<ForgetPasswordController>(
        builder: (controller) {
          return SingleChildScrollView(
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
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.background),
                      borderRadius: BorderRadius.circular(30.w),
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      spacing: 8.h,
                      children: [
                        CommonImage(
                          imageSrc: AppImages.verifyImage,
                          width: 210.w,
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
                    controller: controller.passwordController,
                    borderColor: AppColors.background,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    borderRadius: 30.w,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    hintText: AppString.password,
                    validator: OtherHelper.passwordValidator,
                  ),
                  16.height,
                  CommonTextField(
                    controller: controller.passwordController,
                    borderColor: AppColors.background,
                    textColor: AppColors.background,
                    hintTextColor: AppColors.background,
                    borderRadius: 30.w,
                    fillColor: AppColors.background.withValues(alpha: 0.3),
                    hintText: AppString.newPassword,
                    validator: OtherHelper.passwordValidator,
                  ),
                  38.height,

                  /// Submit Button
                  CommonButtonPro(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.navigation);
                    },
                    text: "Save New Password",
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

// class CreatePassword extends StatelessWidget {
//   CreatePassword({super.key});

//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       /// App Bar Section
//       appBar: AppBar(
//         title: const CommonText(
//           text: AppString.createNewPassword,
//           fontWeight: FontWeight.w700,
//           fontSize: 24,
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF981C2C), // Deep
//                 Color(0xFF821826), // একটু হালকা
//                 Color(0xFF6B1521), // Dark
//                 Color(0xFF55111B), // একটু হালকা
//                 Color(0xFF3E0E16), // Darker
//                 Color(0xFF2D0A10), // Almost darkest
//                 Color(0xFF1F070B),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),

//       /// Body Section
//       body: GetBuilder<ForgetPasswordController>(
//         builder: (controller) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Log In Instruction
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 18.h,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.background),
//                       borderRadius: BorderRadius.circular(30.w),
//                       color: AppColors.white.withValues(alpha: 0.3),
//                     ),
//                     child: Column(
//                       spacing: 8.h,
//                       children: [
//                         CommonImage(
//                           imageSrc: AppImages.verifyImage,
//                           width: 210.w,
//                         ),
//                         CommonText(
//                           text: "Set Your New Password",
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.background,
//                         ),
//                         CommonText(
//                           maxLines: 3,
//                           textAlign: TextAlign.center,
//                           text:
//                               "Create a new password for your account. Make sure it’s strong and secure.",
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.background,
//                         ),
//                       ],
//                     ),
//                   ),
//                   44.height,

//                   CommonTextField(
//                     controller: controller.passwordController,
//                     borderColor: AppColors.background,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     borderRadius: 30.w,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     hintText: AppString.password,
//                     validator: OtherHelper.passwordValidator,
//                   ),
//                   16.height,
//                   CommonTextField(
//                     controller: controller.passwordController,
//                     borderColor: AppColors.background,
//                     textColor: AppColors.background,
//                     hintTextColor: AppColors.background,
//                     borderRadius: 30.w,
//                     fillColor: AppColors.background.withValues(alpha: 0.3),
//                     hintText: AppString.newPassword,
//                     validator: OtherHelper.passwordValidator,
//                   ),
//                   38.height,

//                   /// Submit Button
//                   CommonButtonPro(text: "Save New Password"),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
