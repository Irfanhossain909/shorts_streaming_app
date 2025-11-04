import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';

class SubCard extends StatelessWidget {
  const SubCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.background.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(12.w),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF981C2C), // top shadow
            Color(0xFF981C2C),
            Color(0xFF981C2C).withValues(alpha: .6), // bottom shadow
          ],
          stops: [
            0.0,
            0.7, // 70% red
            1.0, // 30% black
          ],
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          CommonText(
            text: "Weekly pass pro",
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.background,
          ),
          CommonText(
            text: "Unlock all the series for one week",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.background,
          ),
          CommonButton(
            isGradient: false,
            borderColor: AppColors.buton,
            buttonColor: AppColors.buton,
            titleText: "Subscribe now",
          ),
          Align(
            alignment: Alignment.center,
            child: CommonText(
              text: r"renew at $ 199.00/week",
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
