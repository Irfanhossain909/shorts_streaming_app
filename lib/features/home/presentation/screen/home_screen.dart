import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/coming_soon_card.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/card/vip_movie_card.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
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
                  // Search Bar at top
                  _buildSearchBar(),

                  20.height,

                  // Category Filter
                  CategoryFilter(
                    categories: controller.categories,
                    selectedCategory: controller.selectedCategory.value,
                    onCategorySelected: controller.selectCategory,
                  ),

                  20.height,

                  // Conditional content based on selected category
                  if (controller.selectedCategory.value == 'VIP') ...[
                    // VIP Section with Daily/Weekly filters
                    SectionHeader(
                      title: 'Top VIP Picks',
                      subFilters: controller.vipFilters,
                      selectedSubFilter: controller.selectedVipFilter.value,
                      onSubFilterSelected: controller.selectVipFilter,
                    ),

                    20.height,

                    // VIP Movies Grid
                    _buildVipMoviesGrid(controller),

                    30.height,

                    // Only on Thisflix Section
                    SectionHeader(title: 'Only on Thisflix'),

                    20.height,

                    _buildOnlyOnThisflixSection(controller),
                  ] else if (controller.selectedCategory.value == 'New') ...[
                    // Coming Soon Section
                    SectionHeader(title: 'Coming Soon'),

                    20.height,

                    _buildComingSoonSection(controller),

                    30.height,

                    // New Release Section
                    SectionHeader(title: 'New Release'),

                    20.height,

                    _buildNewReleaseSection(controller),
                  ] else ...[
                    // Regular category content
                    SectionHeader(title: controller.selectedCategory.value),

                    20.height,

                    _buildMoviesGrid(controller),
                  ],

                  30.height,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'Good Evening, ${controller.userName.value}!',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                4.height,
                Text(
                  'What you want to watch?',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: TextField(
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.white.withValues(alpha: 0.6),
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

  Widget _buildVipMoviesGrid(HomeController controller) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.currentVipMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.currentVipMovies[index];
          return VipMovieCard(
            title: movie['title'],
            subtitle: movie['subtitle'],
            imageUrl: movie['imageUrl'],
            badge: movie['badge'],
            ranking: movie['ranking'],
            onTap: () => controller.onMovieTap(movie['title']),
          );
        },
      ),
    );
  }

  Widget _buildOnlyOnThisflixSection(HomeController controller) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 12.w),
            child: VipMovieCard(
              title: movie['title'],
              subtitle: movie['subtitle'],
              imageUrl: movie['imageUrl'],
              isLarge: true,
              onTap: () => controller.onMovieTap(movie['title']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComingSoonSection(HomeController controller) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.comingSoonMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.comingSoonMovies[index];
          return ComingSoonCard(
            title: movie['title'],
            subtitle: movie['subtitle'],
            imageUrl: movie['imageUrl'],
            releaseDate: movie['releaseDate'],
            onTap: () => controller.onMovieTap(movie['title']),
            onRemindMeTap: () => controller.onRemindMeTap(movie['title']),
          );
        },
      ),
    );
  }

  Widget _buildNewReleaseSection(HomeController controller) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 12.w),
            child: VipMovieCard(
              title: movie['title'],
              subtitle: movie['subtitle'],
              imageUrl: movie['imageUrl'],
              isLarge: true,
              onTap: () => controller.onMovieTap(movie['title']),
            ),
          );
        },
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
