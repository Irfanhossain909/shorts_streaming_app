import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/features/notifications/presentation/widgets/notification_shimmer.dart';
import '../controller/notifications_controller.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      builder: (controller) {
        return Obx(() {
          return Scaffold(
            appBar: CommonAppBar(
              title: "",
              actions: [
                TextButton(
                  onPressed: () {
                    controller.allNotificationRead();
                  },
                  child: CommonText(
                    text: "Read All",
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),

            body:
                controller.isNotificationLoding.value &&
                    controller.notificationList.isEmpty
                ? ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: 6,
                    itemBuilder: (_, index) {
                      return const NotificationShimmerCard();
                    },
                  )
                : controller.notificationList.isEmpty
                ? Center(child: CommonText(text: "No notifications"))
                : RefreshIndicator(
                    onRefresh: () async {
                      controller.refreshNotification();
                    },
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 10.sp,
                      ),
                      itemCount: controller.notificationList.length + 1,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == controller.notificationList.length) {
                          return Obx(() {
                            if (controller.isNotificationMoreLode.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CommonText(
                                    text: 'No more notifications',
                                    color: AppColors.background,
                                  ),
                                ),
                              );
                            }
                          });
                        }
                        final notification = controller.notificationList[index];

                        ///  Notification card item
                        return NotificationItem(
                          isUnread: notification.read ?? true,
                          title: notification.title,
                          subTitle: notification.message,
                          time: notification.createdAt.toString(),
                          onTap: () {
                            controller.singleNotificationRead(
                              notificationId: notification.id ?? "",
                            );
                          },
                        );
                      },
                    ),
                  ),
          );
        });
      },
    );
  }
}
