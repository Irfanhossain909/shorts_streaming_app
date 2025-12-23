import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/other_widgets/category_filter.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/home/presentation/widgets/coming_soon_section.dart';
import 'package:testemu/features/home/presentation/widgets/fantasy_section.dart';
import 'package:testemu/features/home/presentation/widgets/featured_movies_carousel.dart';
import 'package:testemu/features/home/presentation/widgets/home_header.dart';
import 'package:testemu/features/home/presentation/widgets/library_section.dart';
import 'package:testemu/features/home/presentation/widgets/movies_grid_section.dart';
import 'package:testemu/features/home/presentation/widgets/ranking_section.dart';
import 'package:testemu/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:testemu/features/home/presentation/widgets/vip_movies_section.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
        ),
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
                      20.height,

                      // Popular Movie Section
                      // const PopularMovieSection(),
                      // 20.height,

                      // Featured Movies Carousel
                      FeaturedMoviesCarousel(
                        controller: controller,
                        onWatchTap: controller.onWatchTap,
                        onBookmarkTap: controller.onBookmarkTap,
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 160.h,
                    maxHeight: 160.h,
                    child: Container(
                      decoration: BoxDecoration(
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
                      ),
                      child: Column(
                        children: [
                          25.height,
                          // Search Bar
                          const SearchBarWidget(),
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
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,

                  // Conditional content based on selected category
                  _buildCategoryContent(controller),

                  30.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(HomeController controller) {
    switch (controller.selectedCategory.value) {
      case 'VIP':
        return VipMoviesSection(controller: controller);
      case 'New':
        return ComingSoonSection(controller: controller);
      case 'Ranking':
        return RankingSection(controller: controller);
      case 'Library':
        return LibrarySection(controller: controller);
      case 'Fantasy':
        return FantasySection(controller: controller);
      default:
        return MoviesGridSection(controller: controller);
    }
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
