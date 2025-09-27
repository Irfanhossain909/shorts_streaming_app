import 'dart:ui'; // for blur effect
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/verify_screen.dart';
import 'package:testemu/features/auth/sign%20in/presentation/screen/sign_in_screen.dart';
import 'package:testemu/features/auth/sign%20up/presentation/screen/sign_up_screen.dart';
import 'package:testemu/features/navigation_bar/presentation/controller/navigation_screen_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NavigationScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                const SignInScreen(),
                const SignUpScreen(),
                const VerifyScreen(),
                CreatePassword(),
              ],
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.circular(16), // optional rounded corners
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // blur effect
              child: Container(
                padding: EdgeInsets.only(bottom: 25.w, top: 25.w),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(
                    alpha: 0.3,
                  ), // transparent bg
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Obx(
                  () => SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        final isSelected =
                            controller.selectedIndex.value == index;
                        final iconPaths = [
                          AppImages.nav1,
                          AppImages.nav2,
                          AppImages.nav3,
                          AppImages.nav4,
                        ];

                        return GestureDetector(
                          onTap: () => controller.changeIndex(index),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: isSelected
                                ? const BoxDecoration(
                                    color: AppColors.red2,
                                    shape: BoxShape.circle,
                                  )
                                : null,
                            child: CommonImage(
                              imageSrc: iconPaths[index],
                              width: 24,
                              height: 24,
                              imageColor: isSelected
                                  ? Colors.white
                                  : AppColors.background,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
