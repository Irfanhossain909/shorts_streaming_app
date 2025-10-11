import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'dart:async';

class FeaturedMoviesCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> movies;
  final Function(String) onWatchTap;
  final Function(String) onBookmarkTap;

  const FeaturedMoviesCarousel({
    super.key,
    required this.movies,
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85, // Shows parts of adjacent cards
      initialPage: 0,
    );

    // Auto-scroll functionality with debouncing
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && widget.movies.isNotEmpty) {
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
        final nextIndex = (_currentIndex + 1) % widget.movies.length;

        _pageController.animateToPage(
          nextIndex,
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

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _debounceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 220.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(), // Smooth scrolling physics
            onPageChanged: _onPageChanged,
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final isCenter = index == _currentIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic, // Smooth easing curve
                // margin: EdgeInsets.symmetric(
                //   horizontal: 8.w,
                //   vertical: isCenter ? 0 : 8.h, // Equal height maintained
                // ),
                child: Transform.scale(
                  scale: isCenter ? 1.05 : 0.90, // Subtle scale difference
                  child: Opacity(
                    opacity: isCenter ? 1.0 : 0.85, // Subtle opacity difference
                    child: FeaturedMovieCard(
                      title: movie['title'] ?? '',
                      duration: movie['duration'] ?? '',
                      imageUrl: movie['imageUrl'] ?? '',
                      onWatchTap: () => widget.onWatchTap(movie['title'] ?? ''),
                      onBookmarkTap: () =>
                          widget.onBookmarkTap(movie['title'] ?? ''),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // // Animated dots indicator
        // 16.height,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(
        //     widget.movies.length,
        //     (index) => AnimatedContainer(
        //       duration: const Duration(milliseconds: 300),
        //       curve: Curves.easeInOutCubic,
        //       margin: EdgeInsets.symmetric(horizontal: 3.w),
        //       width: _currentIndex == index ? 20.w : 8.w,
        //       height: 8.h,
        //       decoration: BoxDecoration(
        //         color: _currentIndex == index
        //             ? Colors.white
        //             : Colors.white.withValues(alpha: 0.4),
        //         borderRadius: BorderRadius.circular(4.r),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
