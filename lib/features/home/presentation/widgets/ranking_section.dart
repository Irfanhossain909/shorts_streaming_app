import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/ranking_card.dart';
import 'package:testemu/core/component/other_widgets/secondary_filter.dart';
import 'package:testemu/core/component/shimmer/list_item_shimmer.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class RankingSection extends StatelessWidget {
  final HomeController controller;

  const RankingSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Movie> movies = controller.filteredMoviesBySelectedCategory;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ranking Section with secondary filters
          SecondaryFilter(
            filters: controller.rankingFilters,
            selectedFilter: controller.selectedRankingFilter.value,
            onFilterSelected: controller.selectRankingFilter,
          ),

          20.height,

          // Show shimmer while loading
          if (controller.isLoading.value)
            SizedBox(
              height: 600.h,
              child: const VerticalListShimmer(itemCount: 5),
            )
          else
            // Ranking List
            _buildRankingList(movies),
        ],
      );
    });
  }

  Widget _buildRankingList(List<Movie> movies) {
    return Column(
      children: movies.map((movie) {
        return RankingCard(
          title: movie.title,
          subtitle: movie.description,
          imageUrl: OtherHelper.getImageUrl(
            movie.thumbnail,
            defaultAsset: AppImages.m1,
          ),
          ranking: movie.rating.toInt(),
          isHot: false,
          onTap: () => controller.onMovieTap(movie.id),
        );
      }).toList(),
    );
  }
}
