import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/card/featured_movie_card.dart';
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

  // Track bookmarked movies
  final Set<String> _bookmarkedMovies = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.45, // Shows 3 cards at a time
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
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 288.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(), // Smooth scrolling physics
            onPageChanged: _onPageChanged,
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final isCenter = index == _currentIndex;
              final title = movie['title'] ?? '';
              final isBookmarked = _bookmarkedMovies.contains(title);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic, // Smooth easing curve
                width: isCenter ? 70.w : 60.w,
                height: isCenter ? 120.h : 100.h,
                // margin: EdgeInsets.symmetric(
                //   horizontal: 4.w,
                //   vertical: isCenter ? 0 : 10.h,
                // ),
                child: Transform.scale(
                  scale: isCenter ? 1.0 : 0.85,
                  child: Opacity(
                    opacity: isCenter ? 1.0 : 0.7,
                    child: FeaturedMovieCard(
                      title: title,
                      duration: movie['duration'] ?? '',
                      imageUrl: movie['imageUrl'] ?? '',
                      isBookmarked: isBookmarked,
                      onWatchTap: () => widget.onWatchTap(title),
                      onBookmarkTap: () => _toggleBookmark(title),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
