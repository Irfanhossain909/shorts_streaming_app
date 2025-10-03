import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class LibrarySection extends StatelessWidget {
  final HomeController controller;

  const LibrarySection({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
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
        // Library Movies Grid
        _buildMoviesGrid(),
      ],
    );
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
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return TopChartCard(
            title: movie['title'],
            imageUrl: movie['imageUrl'],
            view: movie['views'] ?? '0',
            onTap: () => controller.onMovieTap(movie['title']),
          );
        },
      ),
    );
  }
}
