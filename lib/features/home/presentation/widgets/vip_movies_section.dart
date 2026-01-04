import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/card/vip_movie_card.dart';
import 'package:testemu/core/component/other_widgets/secondary_filter.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class VipMoviesSection extends StatelessWidget {
  final HomeController controller;

  const VipMoviesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Top VIP Picks',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SecondaryFilter(
            filters: controller.vipFilters,
            selectedFilter: controller.selectedVipFilter.value,
            onFilterSelected: controller.selectVipFilter,
          ),

          20.height,

          // VIP Movies Grid
          _buildVipMoviesGrid(movies),
          10.height,
          _buildVipMoviesGrid(movies),
          10.height,
          _buildVipMoviesGrid(movies),

          30.height,

          // Only on Thisflix Section
          SectionHeader(title: 'Only on Thisflix'),

          20.height,

          _buildOnlyOnThisflixSection(movies),
        ],
      );
    });
  }

  Widget _buildVipMoviesGrid(List<Movie> movies) {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 200.w,
            margin: EdgeInsets.only(right: 12.w),
            child: VipMovieCard(
              title: movie.title,
              subtitle: movie.description,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m4,
              ),
              badge: movie.genre,
              ranking: movie.rating.toString(),
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnlyOnThisflixSection(List<Movie> movies) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: MovieCard(
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
