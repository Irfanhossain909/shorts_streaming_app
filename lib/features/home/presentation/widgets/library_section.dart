import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/component/shimmer/movie_card_shimmer.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class LibrarySection extends StatelessWidget {
  final HomeController controller;

  const LibrarySection({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Library Section with Daily/Weekly filters
          Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Library',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SectionHeader(
            subFilters: controller.libraryMovies,
            selectedSubFilter: controller.selectedLibraryCategory.value,
            onSubFilterSelected: (value) {
              controller.selectedLibraryCategory.value = value;
            },
          ),
          SectionHeader(
            subFilters: controller.libraryMovies2,
            selectedSubFilter: controller.selectedLibraryCategory.value,
            onSubFilterSelected: (value) {
              controller.selectedLibraryCategory.value = value;
            },
          ),
          SectionHeader(
            subFilters: controller.libraryMovies3,
            selectedSubFilter: controller.selectedLibraryCategory.value,
            onSubFilterSelected: (value) {
              controller.selectedLibraryCategory.value = value;
            },
          ),

          20.height,
          // Show shimmer while loading
          if (controller.isLoading.value)
            const MoviesGridShimmer(itemCount: 8)
          else
            // Library Movies Grid
            _buildMoviesGrid(),
        ],
      );
    });
  }

  Widget _buildMoviesGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.60,
        ),
        itemCount: controller.filteredMoviesBySelectedCategory.length,
        itemBuilder: (context, index) {
          final movie = controller.filteredMoviesBySelectedCategory[index];
          return TopChartCard(
            title: movie.title,
            imageUrl: OtherHelper.getImageUrl(
              movie.thumbnail,
              defaultAsset: AppImages.m1,
            ),
            view: movie.totalViews.toString(),
            onTap: () => controller.onMovieTap(movie.id),
          );
        },
      ),
    );
  }
}
