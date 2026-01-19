import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class NotificationItem extends StatelessWidget {
  final bool isUnread;
  final String? title;
  final String? subTitle;
  final String? time;
  final VoidCallback? onTap;
  const NotificationItem({
    super.key,
    this.isUnread = true,
    this.title,
    this.subTitle,
    this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent, // ripple effect off
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: !isUnread ? AppColors.buton.withOpacity(0.9) : null,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.buton),
        ),
        child: Row(
          children: [
            /// icon or image here
            CircleAvatar(
              backgroundColor: AppColors.buton,
              radius: 24.r,
              child: const ClipOval(
                child: Icon(
                  Icons.notifications_active,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title ?? "item.type",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    color: AppColors.white,
                  ),

                  /// Notification Message here
                  CommonText(
                    text: subTitle ?? "item.message",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    color: AppColors.white,
                    textAlign: TextAlign.start,
                    bottom: 10,
                    top: 4,
                  ),

                  /// Notification Time here
                  Align(
                    alignment: Alignment.centerRight,
                    child: CommonText(
                      text: formatNotificationTime(time),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                      color: AppColors.white,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNotificationTime(dynamic input) {
  if (input == null) return 'Invalid time';

  DateTime? dateTime;

  // Input type check
  if (input is DateTime) {
    dateTime = input;
  } else if (input is String && input.isNotEmpty) {
    try {
      dateTime = DateTime.parse(input);
    } catch (e) {
      return 'Invalid time';
    }
  } else {
    return 'Invalid time';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks}w ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '${months}m ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '${years}y ago';
  }
}
