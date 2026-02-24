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
      /// 🔹 LOADING STATE
      if (controller.isLoading.value) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Coming Soon'),
              20.height,
              const HorizontalListShimmer(itemCount: 3, itemHeight: 320),
              30.height,
              SectionHeader(title: 'New Release'),
              20.height,
              const MoviesGridShimmer(itemCount: 6),
            ],
          ),
        );
      }

      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;

      /// 🔹 MAIN SCROLL VIEW
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Coming Soon
            SectionHeader(title: 'Coming Soon'),
            20.height,
            _buildComingSoonMovies(),

            30.height,

            /// New Release
            SectionHeader(title: 'New Release'),
            20.height,
            _buildNewReleaseMovies(movies),

            40.height,
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Coming Soon (Horizontal scroll OK)
  // ---------------------------------------------------------------------------
  Widget _buildComingSoonMovies() {
    return SizedBox(
      height: 320.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // horizontal scroll allowed
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.reminders.length,
        itemBuilder: (context, index) {
          final reminder = controller.reminders[index];
          return ComingSoonCard(
            title: reminder.name,
            imageUrl:
                ApiEndPoint.instance.imageUrl + (reminder.thumbnail ?? ''),
            releaseDate: reminder.reminderTime.date,
            onRemindMeTap: () => controller.onRemindMeTap(reminder.id),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // New Release (❌ Grid scroll disabled, parent scroll handles everything)
  // ---------------------------------------------------------------------------
  Widget _buildNewReleaseMovies(List<Movie> movies) {
    return GridView.builder(
      shrinkWrap: true, // 🔥 important
      physics: const NeverScrollableScrollPhysics(), // 🔥 disable grid scroll
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
    );
  }
}
