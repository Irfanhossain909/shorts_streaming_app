import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/card/most_popular_card.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class FantasySection extends StatelessWidget {
  final HomeController controller;

  const FantasySection({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
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
        _buildMostPeopleMovies(),
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
        _buildNewReleaseMovies(),
      ],
    );
  }

  Widget _buildNewReleaseMovies() {
    return SizedBox(
      height: 380.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return Container(
            width: 200.w,
            margin: EdgeInsets.only(right: 12.w),
            child: TopChartCard(
              title: movie['title'],
              imageUrl: movie['imageUrl'],
              view: movie['views'] ?? '0',
              onTap: () => controller.onMovieTap(movie['title']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMostPeopleMovies() {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return Container(
            width: 130.w,
            margin: EdgeInsets.only(right: 4.w),
            child: MostPopularCard(
              ranking: index + 1,
              imageUrl: movie['imageUrl'],
              onTap: () => controller.onMovieTap(movie['title']),
            ),
          );
        },
      ),
    );
  }
}
