import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

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
          // Regular category content
          10.height,

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
            imageUrl: movie.thumbnail ?? '',
            badge: movie.genre,
            onTap: () => controller.onMovieTap(movie.title),
          );
        },
      ),
    );
  }
}
