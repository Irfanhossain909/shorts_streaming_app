import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';

class MyListScree extends StatelessWidget {
  const MyListScree({super.key});

  @override
  Widget build(BuildContext context) {
    //final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.red2, // প্রথম color
                  Colors.transparent, // শেষ color
                  Colors.transparent, // শেষ color
                  Colors.transparent, // শেষ color
                  Colors.transparent, // শেষ color
                  Colors.transparent, // শেষ color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(controller),
                    20.height,
                    CategoryFilter(
                      categories: controller.myListCategories,
                      selectedCategory: controller.selectedMyListCategory.value,
                      onCategorySelected: controller.selectMyListCategory,
                    ),
                    20.height,
                    _buildMoviesGrid(controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'My List',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => NotificationScreen()),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.50,
        ),
        itemCount: controller.movies.length,
        itemBuilder: (context, index) {
          final movie = controller.movies[index];
          return MovieCard(
            title: movie['title'],
            imageUrl: movie['imageUrl'],
            badge: movie['badge'],
            onTap: () => controller.onMovieTap(movie['title']),
          );
        },
      ),
    );
  }
}
