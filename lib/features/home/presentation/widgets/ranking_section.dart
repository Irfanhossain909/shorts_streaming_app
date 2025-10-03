import 'package:flutter/material.dart';
import 'package:testemu/core/component/card/ranking_card.dart';
import 'package:testemu/core/component/other_widgets/secondary_filter.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class RankingSection extends StatelessWidget {
  final HomeController controller;

  const RankingSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ranking Section with secondary filters
        SecondaryFilter(
          filters: controller.rankingFilters,
          selectedFilter: controller.selectedRankingFilter.value,
          onFilterSelected: controller.selectRankingFilter,
        ),

        20.height,

        // Ranking List
        _buildRankingList(),
      ],
    );
  }

  Widget _buildRankingList() {
    return Column(
      children: controller.currentRankingMovies.map((movie) {
        return RankingCard(
          title: movie['title'],
          subtitle: movie['subtitle'],
          imageUrl: movie['imageUrl'],
          ranking: movie['ranking'],
          isHot: movie['isHot'] ?? false,
          onTap: () => controller.onMovieTap(movie['title']),
        );
      }).toList(),
    );
  }
}