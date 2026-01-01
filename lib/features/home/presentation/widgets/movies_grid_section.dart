import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/home/presentation/widgets/featured_movies_carousel.dart';

class MoviesGridSection extends StatelessWidget {
  final HomeController controller;

  const MoviesGridSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
          // Regular category content
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.50,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            title: movie.title,
            imageUrl: OtherHelper.getImageUrl(
              movie.thumbnail,
              defaultAsset: AppImages.m1,
            ),
            badge: movie.genre,
            onTap: () => controller.onMovieTap(movie.id),
          );
        },
      ),
    );
  }
}
