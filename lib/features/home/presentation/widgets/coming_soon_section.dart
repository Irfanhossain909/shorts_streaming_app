import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/card/coming_soon_card.dart';
import 'package:testemu/core/component/card/top_chart_card.dart';
import 'package:testemu/core/component/other_widgets/section_header.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';

class ComingSoonSection extends StatelessWidget {
  final HomeController controller;

  const ComingSoonSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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

        _buildNewReleaseMovies(),
      ],
    );
  }

  Widget _buildComingSoonMovies() {
    return SizedBox(
      height: 320.h,
      child: ListView.builder(
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

  Widget _buildNewReleaseMovies() {
    return SizedBox(
      height: 700.h,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          childAspectRatio: 1.5,
        ),
        itemCount: controller.onlyOnThisflixMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.onlyOnThisflixMovies[index];
          return Container(
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
}
