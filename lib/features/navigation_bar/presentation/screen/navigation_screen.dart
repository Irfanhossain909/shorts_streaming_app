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

  // Cache icon paths to avoid recreation
  static const List<String> _iconPaths = [
    AppImages.nav1,
    AppImages.nav2,
    AppImages.nav3,
    AppImages.nav4,
  ];

  // Cache border radius
  static const _bottomBarBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationScreenController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                // Use single Obx for IndexedStack
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RepaintBoundary(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 28.w, top: 28.w),
                      decoration: BoxDecoration(
                        // Use solid color instead of blur for better performance
                        color: AppColors.grey.withValues(alpha: 0.85),
                        borderRadius: _bottomBarBorderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final selectedIndex = controller.selectedIndex.value;
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
              ],
            ),
          ),
        );
      },
    );
  }
}

// Separate widget to optimize rebuilds
class _NavigationItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const _NavigationItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  static final _selectedDecoration = BoxDecoration(
    color: AppColors.red2,
    shape: BoxShape.circle,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: isSelected ? _selectedDecoration : null,
        child: CommonImage(
          imageSrc: NavigationScreen._iconPaths[index],
          width: 24.w,
          height: 24.w,
          imageColor: isSelected ? Colors.white : AppColors.background,
        ),
      ),
    );
  }
}
