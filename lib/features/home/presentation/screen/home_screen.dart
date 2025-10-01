import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(controller),

                  20.height,

                  // Popular Movie Section
                  _buildPopularMovieSection(),

                  20.height,

                  // Featured Movie Card
                  FeaturedMovieCard(
                    title: controller.featuredMovie['title']!,
                    duration: controller.featuredMovie['duration']!,
                    imageUrl: controller.featuredMovie['imageUrl']!,
                    onWatchTap: controller.onWatchTap,
                    onBookmarkTap: controller.onBookmarkTap,
                  ),

                  30.height,

                  // Search Bar
                  _buildSearchBar(),

                  20.height,

                  // Category Filter
                  Obx(
                    () => CategoryFilter(
                      categories: controller.categories,
                      selectedCategory: controller.selectedCategory.value,
                      onCategorySelected: controller.selectCategory,
                    ),
                  ),

                  20.height,

                  // Movies Grid
                  _buildMoviesGrid(controller),

                  20.height,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening, ${controller.userName.value}!',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              4.height,
              Obx(
                () => Text(
                  'What you want to watch?',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Container(
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
        ],
      ),
    );
  }

  Widget _buildPopularMovieSection() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Movie',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: TextField(
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: AppColors.white.withValues(alpha: 0.5),
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.white.withValues(alpha: 0.5),
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
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
