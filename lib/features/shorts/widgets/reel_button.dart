import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';

class ReelButton extends StatelessWidget {
  final String? text;
  final String? imgPath;
  const ReelButton({super.key, this.text, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.h,
      children: [
        CommonImage(
          imageColor: AppColors.background,
          imageSrc: imgPath ?? AppImages.shareIc,
          width: 36,
        ),
        CommonText(
          
          text: text ?? "no Text",
          fontSize: 16.h,
          fontWeight: FontWeight.w600,
          color: AppColors.background,
        ),
      ],
    );
  }
}
