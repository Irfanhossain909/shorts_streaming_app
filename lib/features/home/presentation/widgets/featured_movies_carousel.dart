import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/model/banner_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class FeaturedMoviesCarousel extends StatelessWidget {
  final HomeController controller;
  final Function(String) onWatchTap;
  final Function(String, String, ReferenceType) onBookmarkTap;

  const FeaturedMoviesCarousel({
    super.key,
    required this.controller,
    required this.onWatchTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use GetBuilder instead of Obx to avoid unnecessary rebuilds
    // Only rebuild when bannersList actually changes (initial load)
    return GetBuilder<HomeController>(
      id: 'banners_list',
      init: controller,
      builder: (ctrl) {
        final bannersList = ctrl.bannersList;

        if (bannersList.isEmpty) {
          return const SizedBox.shrink();
        }

        // Wrap the static content in RepaintBoundary to prevent rebuilds
        return RepaintBoundary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: CommonText(
                  text: 'Trailers Coming Soon',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ).start,
              ),
              10.height,
              SizedBox(
                height: 288.h,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      controller.onCarouselScrollStart();
                    } else if (notification is ScrollEndNotification) {
                      controller.onCarouselScrollEnd();
                    }
                    return false;
                  },
                  child: PageView.builder(
                    controller: controller.carouselPageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: controller.onCarouselPageChanged,
                    itemCount: bannersList.length,
                    itemBuilder: (context, index) {
                      final trailer = bannersList[index];
                      // Use a stable key to help Flutter optimize rebuilds
                      return _CarouselCard(
                        key: ValueKey('carousel_${trailer.id}_$index'),
                        index: index,
                        trailer: trailer,
                        controller: controller,
                        onWatchTap: onWatchTap,
                      );
                    },
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

// Optimized card widget that minimizes rebuilds
// Only rebuilds when this specific card's state changes (index or bookmark)
class _CarouselCard extends StatelessWidget {
  final int index;
  final Trailer trailer;
  final HomeController controller;
  final Function(String) onWatchTap;

  const _CarouselCard({
    super.key,
    required this.index,
    required this.trailer,
    required this.controller,
    required this.onWatchTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = trailer.title;

    // Use GetBuilder with specific IDs to only rebuild when needed
    // 'carousel_index_$index' is only updated when THIS card becomes center/not center
    // 'carousel_bookmark_$index' is only updated when THIS card's bookmark changes
    return GetBuilder<HomeController>(
      id: 'carousel_index_$index',
      init: controller,
      builder: (ctrl) {
        final currentIndex = ctrl.carouselCurrentIndex.value;
        final isCenter = index == currentIndex;

        // Nested GetBuilder for bookmark state (only this card rebuilds)
        return GetBuilder<HomeController>(
          id: 'carousel_bookmark_$index',
          init: controller,
          builder: (ctrl) {
            final isBookmarked = ctrl.bookmarkedMovies.contains(title);

            // Use AnimatedScale and AnimatedOpacity for smooth transitions
            // These widgets are optimized by Flutter and don't rebuild the child widget tree
            // RepaintBoundary isolates repaints to this card only
            return RepaintBoundary(
              child: AnimatedScale(
                scale: isCenter ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: isCenter ? 1.0 : 0.7,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  // Cache the expensive card widget with a stable key
                  // This prevents the card from rebuilding unnecessarily
                  child: FeaturedMovieCard(
                    key: ValueKey('card_${trailer.id}'),
                    title: title,
                    duration: trailer.duration,
                    imageUrl: "https://${trailer.thumbnailUrl}",
                    isBookmarked: isBookmarked,
                    onWatchTap: () => onWatchTap(trailer.videoUrl),
                    onBookmarkTap: () =>
                        ctrl.toggleCarouselBookmark(title, trailer.id),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
