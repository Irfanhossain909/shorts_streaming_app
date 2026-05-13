import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_icons.dart';
import 'package:testemu/features/home/presentation/screen/home_screen.dart';
import 'package:testemu/features/my_list/presenter/screen/my_list_scree.dart';
import 'package:testemu/features/navigation_bar/presentation/controller/navigation_screen_controller.dart';
import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';
import 'package:testemu/features/shorts/presenter/shorts_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  // Cache icon paths
  static const List<String> _iconPaths = [
    AppIcons.icHome,
    AppIcons.icShorts,
    AppIcons.icLibrary,
    AppIcons.icProfile,
  ];

  // Border radius
  static const BorderRadius _bottomBarBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationScreenController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                /// Screens
                Obx(() {
                  final index = controller.selectedIndex.value;

                  return IndexedStack(
                    index: index,
                    children: [
                      HomeScreen(),
                      ShortsFeedScreen(),
                      const MyListScree(),
                      const ProfileScreen(),
                    ],
                  );
                }),

                /// Bottom Navigation
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: _bottomBarBorderRadius,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: _bottomBarBorderRadius,
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),

                            // Only top shadow/glow
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            final selectedIndex =
                                controller.selectedIndex.value;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                4,
                                (index) => _NavigationItem(
                                  index: index,
                                  isSelected: selectedIndex == index,
                                  onTap: controller.changeIndex,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Navigation Item
class _NavigationItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const _NavigationItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  static final BoxDecoration _selectedDecoration = BoxDecoration(
    color: AppColors.red2,
    shape: BoxShape.circle,
  );

  String get _title {
    switch (index) {
      case 0:
        return "Discover";
      case 1:
        return "For You";
      case 2:
        return "My List";
      default:
        return "Profile";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => onTap(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: isSelected ? _selectedDecoration : null,
              child: CommonImage(
                imageSrc: NavigationScreen._iconPaths[index],
                width: 18.w,
                height: 18.h,
                imageColor: isSelected ? Colors.white : AppColors.background,
              ),
            ),

            SizedBox(height: 4.h),

            CommonText(
              text: _title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.background,
            ),
          ],
        ),
      ),
    );
  }
}
