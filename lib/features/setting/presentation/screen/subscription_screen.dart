import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/setting/presentation/widgets/sub_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ""),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CommonText(
                      text: "Subscribe",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                    ),
                    CommonText(
                      text: "Watch more episodes",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.background,
                    ),
                  ],
                ),
                CommonImage(width: 270.w, imageSrc: AppImages.vipCardImg),
              ],
            ),

            SubCard(),
          ],
        ),
      ),
    );
  }
}

