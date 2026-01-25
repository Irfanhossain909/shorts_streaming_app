import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/component/shimmer/movie_card_shimmer.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/home/presentation/widgets/featured_movies_carousel.dart';

class PopularMovieSection extends StatelessWidget {
  final HomeController controller;

  const PopularMovieSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show shimmer while loading
      if (controller.isLoading.value) {
        return Column(
          children: [
            20.height,
            SectionHeader(title: 'You  Might Like'),
            20.height,
            const MoviesGridShimmer(itemCount: 9),
          ],
        );
      }

      // Always use filtered movies (real data from backend)
      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;

      return Column(
        children: [
          // Featured Movies Carousel
          FeaturedMoviesCarousel(
            controller: controller,
            onWatchTap: controller.onWatchTap,
            onBookmarkTap: (title, id, referenceType) async =>
                controller.onBookmarkTap(title, id, referenceType),
          ),
          20.height,
          SectionHeader(title: 'You  Might Like'),
          20.height,

          _buildMoviesGrid(movies),
        ],
      );
    });
  }

  Widget _buildMoviesGrid(List<Movie> movies) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // Optimize ListView/GridView performance
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        cacheExtent: 200.h,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.50,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return RepaintBoundary(
            child: MovieCard(
              key: ValueKey('movie_${movie.id}'),
              title: movie.title,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m1,
              ),
              badge: movie.genre,
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        },
      ),
    );
  }
}
