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
    // Only observe bannersList changes, not the entire widget tree
    return Obx(() {
      final bannersList = controller.bannersList;

      if (bannersList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
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
                  // Use a separate widget that only rebuilds when this specific index changes
                  return _CarouselCard(
                    key: ValueKey('${trailer.id}_$index'),
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
      );
    });
  }
}

// Separate widget that only rebuilds when this specific card's state changes
// Using GetBuilder with selective updates to minimize rebuilds
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

    // Use GetBuilder for both index and bookmark changes with specific IDs
    // This ensures only the affected cards rebuild
    return GetBuilder<HomeController>(
      id: 'carousel_index_$index',
      init: controller,
      builder: (ctrl) {
        final currentIndex = ctrl.carouselCurrentIndex.value;
        final isCenter = index == currentIndex;

        // Use GetBuilder for bookmark state too (only this card rebuilds)
        return GetBuilder<HomeController>(
          id: 'carousel_bookmark_$index',
          init: controller,
          builder: (ctrl) {
            final isBookmarked = ctrl.bookmarkedMovies.contains(title);

            // Use Transform and Opacity for better performance (no animation overhead)
            return RepaintBoundary(
              child: Transform.scale(
                scale: isCenter ? 1.0 : 0.85,
                child: Opacity(
                  opacity: isCenter ? 1.0 : 0.7,
                  child: FeaturedMovieCard(
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
