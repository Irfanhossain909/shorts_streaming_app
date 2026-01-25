import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/coming_soon_card.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/component/shimmer/list_item_shimmer.dart';
import 'package:testemu/core/component/shimmer/movie_card_shimmer.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class ComingSoonSection extends StatelessWidget {
  final HomeController controller;

  const ComingSoonSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show shimmer while loading
      if (controller.isLoading.value) {
        return Column(
          children: [
            SectionHeader(title: 'Coming Soon'),
            20.height,
            const HorizontalListShimmer(itemCount: 3, itemHeight: 320),
            30.height,
            SectionHeader(title: 'New Release'),
            20.height,
            const MoviesGridShimmer(itemCount: 6),
          ],
        );
      }

      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;
      return Column(
        children: [
          // Coming Soon Section
          SectionHeader(title: 'Coming Soon'),

          20.height,

          _buildComingSoonMovies(),

          30.height,

          // New Release Section
          SectionHeader(title: 'New Release'),

          20.height,

          _buildNewReleaseMovies(movies),
        ],
      );
    });
  }

  Widget _buildComingSoonMovies() {
    return SizedBox(
      height: 320.h,
      child: ListView.builder(
        addRepaintBoundaries: true,
        addAutomaticKeepAlives: false,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.reminders.length,
        itemBuilder: (context, index) {
          final reminder = controller.reminders[index];
          return ComingSoonCard(
            title: reminder.name,
            imageUrl:
                ApiEndPoint.instance.imageUrl + (reminder.thumbnail ?? ''),
            releaseDate: reminder.reminderTime.date,
            onTap: () => controller.onMovieTap(reminder.name),
            onRemindMeTap: () => controller.onRemindMeTap(reminder.id),
          );
        },
      ),
    );
  }

  Widget _buildNewReleaseMovies(List<Movie> movies) {
    return SizedBox(
      height: 700.h,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.h,
          childAspectRatio: 0.6,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: TopChartCard(
              title: movie.title,
              imageUrl: OtherHelper.getImageUrl(
                movie.thumbnail,
                defaultAsset: AppImages.m1,
              ),
              view: movie.totalViews.toString(),
              onTap: () => controller.onMovieTap(movie.id),
            ),
          );
        },
      ),
    );
  }
}
