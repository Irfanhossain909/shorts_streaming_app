import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/home/presentation/widgets/coming_soon_section.dart';
import 'package:testemu/features/home/presentation/widgets/fantasy_section.dart';
import 'package:testemu/features/home/presentation/widgets/home_header.dart';
import 'package:testemu/features/home/presentation/widgets/library_section.dart';
import 'package:testemu/features/home/presentation/widgets/movies_grid_section.dart';
import 'package:testemu/features/home/presentation/widgets/popular_movie_section.dart';
import 'package:testemu/features/home/presentation/widgets/ranking_section.dart';
import 'package:testemu/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:testemu/features/home/presentation/widgets/vip_movies_section.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  // Cache gradient decorations to avoid recreation
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
    return Scaffold(
      body: Container(
        decoration: _backgroundGradient,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      HomeHeader(controller: controller),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 160.h,
                    maxHeight: 160.h,
                    child: _StickyHeader(controller: controller),
                  ),
                ),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 10)),

                SliverToBoxAdapter(
                  child: RepaintBoundary(
                    child: Obx(() {
                      if (controller.isSearchActive) {
                        return _buildSearchResults(controller);
                      }
                      return _buildCategoryContent(controller);
                    }),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(HomeController controller) {
    switch (controller.selectedCategory.value.trim().toLowerCase()) {
      case 'popular':
        return PopularMovieSection(controller: controller);
      case 'vip':
        return VipMoviesSection(controller: controller);
      case 'new':
        return ComingSoonSection(controller: controller);
      case 'ranking':
        return RankingSection(controller: controller);
      case 'library':
        return LibrarySection(controller: controller);
      case 'fantasy':
        return FantasySection(controller: controller);
      default:
        return MoviesGridSection(controller: controller);
    }
  }

  Widget _buildSearchResults(HomeController controller) {
    final searchedMovies = controller.searchedMovies;

    if (searchedMovies.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64.sp,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
              16.height,
              Text(
                'No movies found',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.height,
              Text(
                'Try searching with different keywords',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.5),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            'Search Results (${searchedMovies.length})',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildMoviesGrid(searchedMovies, controller),
      ],
    );
  }

  Widget _buildMoviesGrid(List<Movie> movies, HomeController controller) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final movie = movies[index];
          return RepaintBoundary(
            child: MovieCard(
              title: movie.title,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m1,
              ),
              badge: movie.genre,
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        }, childCount: movies.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.50,
        ),
      ),
    );
  }
}

// Separate widget for sticky header to optimize rebuilds
class _StickyHeader extends StatelessWidget {
  final HomeController controller;
  
  const _StickyHeader({required this.controller});

  // Cache gradient decoration
  static const _headerGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _headerGradient,
      child: Column(
        children: [
          10.height,
          // Search Bar
          SearchBarWidget(
            controller: controller.searchController,
            onSearchChanged: (query) {
              controller.updateSearchQuery(query);
            },
            onClear: () {
              controller.clearSearch();
            },
          ),
          10.height,
          Obx(
            () => CategoryFilter(
              categories: controller.categories
                  .map((e) => e.name)
                  .toList(),
              selectedCategory:
                  controller.selectedCategory.value,
              onCategorySelected: controller.selectCategory,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;
  
  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }
}
