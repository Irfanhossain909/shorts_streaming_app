import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/other_widgets/common_loader.dart';
import 'package:testemu/core/component/other_widgets/no_data.dart';

import '../../data/model/notification_model.dart';
import '../controller/notifications_controller.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ""),

      /// App Bar Section starts here

      /// Body Section starts here
      // ignore: avoid_unnecessary_containers
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       AppColors.red2,
        //       Colors.transparent,
        //       Colors.transparent,
        //       Colors.transparent,
        //       Colors.transparent,
        //       Colors.transparent,
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: GetBuilder<NotificationsController>(
          builder: (controller) {
            return controller.isLoading
                /// Loading bar here
                ? const CommonLoader()
                : controller.notifications.isEmpty
                ///  data is Empty then show default Data
                ? const NoData()
                /// show all Notifications here
                : ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.sp,
                      vertical: 10.sp,
                    ),
                    itemCount: controller.isLoadingMore
                        ? controller.notifications.length + 1
                        : controller.notifications.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ///  Notification More Data Loading Bar
                      if (index > controller.notifications.length) {
                        return CommonLoader(size: 40, strokeWidth: 2);
                      }
                      NotificationModel item = controller.notifications[index];

                      ///  Notification card item
                      return NotificationItem(item: item);
                    },
                  );
          },
        ),
      ),
    );
  }
}
