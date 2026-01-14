import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/my_list/presenter/controller/my_list_controller.dart';
import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';

class MyListScree extends StatelessWidget {
  const MyListScree({super.key});

  // Cache gradient to avoid recreation
  static const _backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.red2,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  @override
  Widget build(BuildContext context) {
    //final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      body: GetBuilder<MyListController>(
        builder: (controller) {
          return Container(
            decoration: _backgroundGradient,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(controller),
                    20.height,
                    Obx(
                      () => CategoryFilter(
                        categories: controller.myListCategories,
                        selectedCategory:
                            controller.selectedMyListCategory.value,
                        onCategorySelected: controller.selectMyListCategory,
                      ),
                    ),
                    20.height,
                    Obx(() => _buildContent(controller)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(MyListController controller) {
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

  Widget _buildContent(MyListController controller) {
    // Check which tab is selected
    if (controller.selectedMyListCategory.value == 'Recently Watched') {
      return _buildRecentVideosGrid(controller);
    } else {
      return _buildBookmarksGrid(controller);
    }
  }

  Widget _buildRecentVideosGrid(MyListController controller) {
    if (controller.recentVideos.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: Text(
            'No recently watched videos',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    }

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
        itemCount: controller.recentVideos.length,
        itemBuilder: (context, index) {
          final recentItem = controller.recentVideos[index];
          final video =
              recentItem.videoId!; // Safe because we filter nulls in controller
          return MovieCard(
            title: video.title,
            imageUrl: video.thumbnailUrl,
            badge: 'Episode ${video.episodeNumber}',
            date: recentItem.viewedAt.toLocal().toString().split(' ')[0],
            onTap: () => Get.toNamed(
              AppRoutes.videoDetail,
              arguments: {'videoId': video.movieId},
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookmarksGrid(MyListController controller) {
    if (controller.bookmarks.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: Text(
            'No bookmarked items',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    }

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
        itemCount: controller.bookmarks.length,
        itemBuilder: (context, index) {
          final movie = controller.bookmarks[index];
          return MovieCard(
            title: movie.trailer?.title ?? '',
            imageUrl:
                ApiEndPoint.instance.imageUrl +
                (movie.trailer?.thumbnailUrl ?? ''),
            badge: movie.trailer?.contentName ?? '',
            onTap: () => controller.onMovieTap(
              movie.trailer?.id ?? '',
              movie.referenceType,
              movie.trailer?.videoUrl ?? '',
            ),
          );
        },
      ),
    );
  }
}
