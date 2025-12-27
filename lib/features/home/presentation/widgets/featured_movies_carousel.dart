import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class FeaturedMoviesCarousel extends StatefulWidget {
  final HomeController controller;
  final Function(String) onWatchTap;
  final Function(String) onBookmarkTap;

  const FeaturedMoviesCarousel({
    super.key,
    required this.controller,
    required this.onWatchTap,
    required this.onBookmarkTap,
  });

  @override
  State<FeaturedMoviesCarousel> createState() => _FeaturedMoviesCarouselState();
}

class _FeaturedMoviesCarouselState extends State<FeaturedMoviesCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  Timer? _debounceTimer;

  // Track bookmarked movies
  final Set<String> _bookmarkedMovies = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85, // Shows more of each card, reducing side spacing
      initialPage: 0,
    );

    // Auto-scroll functionality with debouncing
    _startAutoScroll();
    // Safely log trailers info only when data is available
    if (widget.controller.bannersList.isNotEmpty) {
      appLog('trailers: ${widget.controller.bannersList.length}');
      appLog(
        'trailers first thumbnail: '
        '${widget.controller.bannersList.first.thumbnailUrl}',
      );
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && widget.controller.bannersList.isNotEmpty) {
        _autoScroll();
      }
    });
  }

  void _autoScroll() {
    if (!mounted) return;

    // Debounce rapid state changes
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) {
        final nextIndex =
            (_currentIndex + 1) % widget.controller.bannersList.length;

        _pageController.animateToPage(
          nextIndex.toInt(),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    // Debounce page change updates
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted && _currentIndex != index) {
        setState(() {
          _currentIndex = index;
        });
      }
    });
  }

  // Handle bookmark toggle
  void _toggleBookmark(String title) {
    setState(() {
      if (_bookmarkedMovies.contains(title)) {
        _bookmarkedMovies.remove(title);
      } else {
        _bookmarkedMovies.add(title);
      }
    });

    // Call the original bookmark tap handler
    widget.onBookmarkTap(title);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _debounceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.bannersList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
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
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: _onPageChanged,
              itemCount: widget.controller.bannersList.length,
              padEnds: false, // Remove default padding
              itemBuilder: (context, index) {
                final trailer = widget.controller.bannersList[index];
                final isCenter = index == _currentIndex;
                final title = trailer.title;
                final isBookmarked = _bookmarkedMovies.contains(title);

                return Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    width: 120.w,
                    height: double.infinity,
                    child: Transform.scale(
                      scale: isCenter ? 1.0 : 0.85,
                      child: Opacity(
                        opacity: isCenter ? 1.0 : 0.7,
                        child: FeaturedMovieCard(
                          title: title,
                          duration: trailer.duration,
                          imageUrl: "https://${trailer.thumbnailUrl}",
                          isBookmarked: isBookmarked,
                          onWatchTap: () => widget.onWatchTap(title),
                          onBookmarkTap: () => _toggleBookmark(title),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
