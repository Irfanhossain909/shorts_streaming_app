import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';

class ReelButton extends StatelessWidget {
  final String? text;
  final String? imgPath;
  final VoidCallback? onTap;
  const ReelButton({super.key, this.text, this.imgPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.h,
        children: [
          CommonImage(
            imageColor: AppColors.background,
            imageSrc: imgPath ?? AppImages.shareIc,
            width: 28.w,
          ),
          CommonText(
            text: text ?? "no Text",
            fontSize: 14.h,
            fontWeight: FontWeight.w600,
            color: AppColors.background,
          ),
        ],
      ),
    );
  }
}
