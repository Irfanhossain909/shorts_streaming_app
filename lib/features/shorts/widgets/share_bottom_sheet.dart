import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareBottomSheet extends StatelessWidget {
  final String videoId;
  final String title;
  final String? thumbnailUrl;

  const ShareBottomSheet({
    super.key,
    required this.videoId,
    required this.title,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Web link that will be shared - using your domain
    final webLink = 'https://api.creepy-shorts.com/shorts/$videoId';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.buton,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 20.h),

            // Video Preview Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.buttonColor2,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CommonImage(
                      imageSrc:
                          thumbnailUrl ??
                          "https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg",
                      width: 60.w,
                      height: 80.h,
                      fill: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        CommonText(
                          text: "Share this video",
                          fontSize: 12.sp,
                          color: AppColors.white.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Share Options Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CommonText(
                  text: "Share via",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Share Options Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Facebook
                  _ShareOptionButton(
                    iconPath: AppIcons.icFacebook,
                    label: "Facebook",
                    onTap: () {
                      Get.back();
                      _shareToFacebook(webLink, title);
                    },
                  ),

                  // Twitter/X
                  _ShareOptionButton(
                    icon: Icons.close, // X icon (Twitter rebranded to X)
                    label: "X",
                    onTap: () {
                      Get.back();
                      _shareToTwitter(webLink, title);
                    },
                  ),

                  // WhatsApp
                  _ShareOptionButton(
                    icon: Icons.chat_bubble_rounded,
                    label: "WhatsApp",
                    onTap: () {
                      Get.back();
                      _shareToWhatsApp(webLink, title);
                    },
                  ),

                  // More (System Share Sheet)
                  _ShareOptionButton(
                    icon: Icons.share_rounded,
                    label: "More",
                    onTap: () {
                      Get.back();
                      _shareViaSystemSheet(webLink, title);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Copy Link Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: webLink));
                  Get.back();
                  Get.snackbar(
                    "✓ Link Copied",
                    "Video link copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                    margin: EdgeInsets.all(16.w),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.red2,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.link_rounded,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      CommonText(
                        text: "Copy Link",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Cancel Button
            TextButton(
              onPressed: () => Get.back(),
              child: CommonText(
                text: "Cancel",
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withOpacity(0.6),
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void _shareToFacebook(String link, String title) async {
    try {
      // Try Facebook app first
      final facebookAppUrl = Uri.parse(
        'fb://facewebmodal/f?href=${Uri.encodeComponent(link)}',
      );

      if (await canLaunchUrl(facebookAppUrl)) {
        await launchUrl(facebookAppUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to web browser
      final webUrl = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}',
      );
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // If both fail, use system share sheet
      _shareViaSystemSheet(link, title);
    } catch (e) {
      // Last resort: use system share sheet
      _shareViaSystemSheet(link, title);
    }
  }

  void _shareToTwitter(String link, String title) async {
    try {
      final text = Uri.encodeComponent('Check out this video: $title');

      // Try Twitter/X app first
      final twitterAppUrl = Uri.parse(
        'twitter://post?message=$text ${Uri.encodeComponent(link)}',
      );

      if (await canLaunchUrl(twitterAppUrl)) {
        await launchUrl(twitterAppUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to web browser
      final webUrl = Uri.parse(
        'https://twitter.com/intent/tweet?text=$text&url=${Uri.encodeComponent(link)}',
      );
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // If both fail, use system share sheet
      _shareViaSystemSheet(link, title);
    } catch (e) {
      // Last resort: use system share sheet
      _shareViaSystemSheet(link, title);
    }
  }

  void _shareToWhatsApp(String link, String title) async {
    try {
      final text = 'Check out this video: $title\n$link';

      // Try WhatsApp app first
      final whatsappUrl = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent(text)}',
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // Try WhatsApp web as fallback
      final whatsappWebUrl = Uri.parse(
        'https://api.whatsapp.com/send?text=${Uri.encodeComponent(text)}',
      );
      if (await canLaunchUrl(whatsappWebUrl)) {
        await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
        return;
      }

      // If both fail, use system share sheet
      _shareViaSystemSheet(link, title);
    } catch (e) {
      // Last resort: use system share sheet
      _shareViaSystemSheet(link, title);
    }
  }

  void _shareViaSystemSheet(String link, String title) async {
    try {
      // Use share_plus package for system share sheet
      await Share.share('Check out this video: $title\n$link', subject: title);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not share the video",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.all(16.w),
      );
    }
  }
}

class _ShareOptionButton extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOptionButton({
    this.iconPath,
    this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 70.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.buttonColor2,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: iconPath != null
                    ? CommonImage(
                        imageSrc: iconPath!,
                        width: 28.w,
                        height: 28.w,
                        imageColor: AppColors.white,
                      )
                    : Icon(icon, color: AppColors.white, size: 28.sp),
              ),
            ),

            SizedBox(height: 8.h),

            // Label
            CommonText(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withOpacity(0.8),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
