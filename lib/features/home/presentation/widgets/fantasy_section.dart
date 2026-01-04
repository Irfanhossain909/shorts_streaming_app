import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/most_popular_card.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class FantasySection extends StatelessWidget {
  final HomeController controller;

  const FantasySection({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Fantasy Section with Daily/Weekly filters
          Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Most Popular',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildMostPeopleMovies(movies),
          20.height,
          Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Top Chart',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.height,
          _buildNewReleaseMovies(movies),
        ],
      );
    });
  }

  Widget _buildNewReleaseMovies(List<Movie> movies) {
    return SizedBox(
      height: 380.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 200.w,
            margin: EdgeInsets.only(right: 12.w),
            child: TopChartCard(
              title: movie.title,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m4,
              ),
              view: movie.totalViews.toString(),
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMostPeopleMovies(List<Movie> movies) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 130.w,
            margin: EdgeInsets.only(right: 4.w),
            child: MostPopularCard(
              ranking: index + 1,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m1,
              ),
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        },
      ),
    );
  }
}
