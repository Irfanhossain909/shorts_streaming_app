import 'dart:ui'; // for blur effect

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/home/presentation/screen/home_screen.dart';
import 'package:testemu/features/my_list/presenter/screen/my_list_scree.dart';
import 'package:testemu/features/navigation_bar/presentation/controller/navigation_screen_controller.dart';
import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';
import 'package:testemu/features/shorts/presenter/shorts_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Obx(
                () => IndexedStack(
                  index: controller.selectedIndex.value,
                  children: [
                    HomeScreen(),

                    controller.selectedIndex.value == 1
                        ? const ShortsFeedScreen()
                        : Container(),
                    const MyListScree(),
                    ProfileScreen(),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ), // blur effect
                    child: Container(
                      padding: EdgeInsets.only(bottom: 28.w, top: 28.w),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(
                          alpha: 0.3,
                        ), // transparent bg
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Obx(
                        () => Row(
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

                            return InkWell(
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
                                  width: 24.w,
                                  height: 24.w,
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
            ],
          ),
        );
      },
    );
  }
}
