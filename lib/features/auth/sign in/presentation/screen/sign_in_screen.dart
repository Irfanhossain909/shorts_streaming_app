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
        toolbarHeight: 100.h,
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
                    /// Logo + Title
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(vertical: 18.h),
                    //   child: Column(
                    //     children: [
                    //       CommonImage(
                    //         width: 120.w,
                    //         height: 120.h,
                    //         imageSrc: AppImages.appLogoSvg,
                    //       ),
                    //       CommonText(
                    //         text: "Let's Get Started!",
                    //         fontSize: 18.sp,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColors.background,
                    //       ),
                    //       CommonText(
                    //         text: "Let's dive in into your account",
                    //         fontSize: 14.sp,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColors.background,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30.r),
                                  child: Image.network(
                                    image,
                                    height: 200.h,
                                    width: 120.w,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: 200.h,
                                            width: 120.w,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200.h,
                                        width: 120.w,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 60.h,
                                  child: CommonText(
                                    textAlign: TextAlign.center,
                                    text: "ETHERION",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.background,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    24.height,

                    /// Email
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

List<String> images = [
  "https://i.pinimg.com/736x/74/fa/68/74fa6885bb5f81d12f3355f91b548774.jpg",
  "https://i.pinimg.com/736x/b5/d2/0e/b5d20e4019e096d3f88761e3372bb4b6.jpg",
  "https://i.pinimg.com/736x/28/98/6a/28986a3eae1b08152608708e0b8cf640.jpg",
  "https://i.pinimg.com/1200x/48/26/3c/48263cce012ec8fe615348f6534b11f2.jpg",
  "https://i.pinimg.com/736x/83/2a/79/832a792dd5cc2a53ae89b7222b98c278.jpg",
  "https://i.pinimg.com/1200x/81/b4/0e/81b40e82fc8a04ec3839c2227c4c26f4.jpg",
  "https://i.pinimg.com/1200x/f6/a9/3c/f6a93c595c761afa20a1c1faa14f3a53.jpg",
  "https://i.pinimg.com/1200x/7b/8c/68/7b8c6882f86aa3276a60b5c7aa308830.jpg",
  "https://i.pinimg.com/736x/b1/2b/b4/b12bb45e9628edc3c5971140820f4612.jpg",
];
