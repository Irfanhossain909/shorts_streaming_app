import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/notifications/data/model/notification_model.dart';
import 'package:testemu/features/notifications/repository/notification_repository.dart';

class NotificationsController extends GetxController {
  int limit = 12;
  int page = 1;

  final NotificationRepository notificationRepository =
      NotificationRepository.instance;

  RxList<Result> notificationList = <Result>[].obs;

  ScrollController scrollController = ScrollController();

  RxBool isNotificationMoreLode = true.obs;
  RxBool isNotificationLoding = false.obs;

  RxInt unreadCount = 0.obs;

  // ------------------ Main function ------------------

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      _scrollNotification();
    });
    fetchNorification();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // ------------------ <<<<<<<=================>>>>> ------------------

  void allNotificationRead() async {
    try {
      final response = await notificationRepository.readAllNotification();

      if (response) {
        // Loop through all notifications and mark unread ones as read
        for (var notification in notificationList) {
          if (notification.read == false) {
            notification.read = true;
          }
        }

        // Refresh the list to update UI (if using GetX RxList)
        notificationList.refresh();
        unreadCount.value = 0;
      }
    } catch (e) {
      appLog("Error reading all notifications: $e");
    }
  }

  void singleNotificationRead({required String notificationId}) async {
    try {
      final response = await notificationRepository.readNotification(
        notificationId: notificationId,
      );

      if (response) {
        // Find the notification in the list
        final index = notificationList.indexWhere(
          (element) => element.id == notificationId,
        );
        if (index != -1) {
          // Mark it as read
          notificationList[index].read = true;

          // Refresh the list to update UI (if using GetX RxList)
          notificationList.refresh();
          if (unreadCount.value > 0) {
            unreadCount.value--;
          }
        }
      }
    } catch (e) {
      appLog("Error reading notification: $e");
    }
  }

  Future<void> fetchNorification() async {
    if (isNotificationLoding.value) return;

    try {
      if (page == 1) {
        isNotificationLoding.value = true;
      }

      final response = await notificationRepository.getNotifications(
        page: page.toString(),
        limit: limit.toString(),
      );

      if (response.data != null) {
        final notifications = response.data?.result ?? [];
        notificationList.addAll(notifications);
        unreadCount.value = response.data?.unreadCount ?? 0;

        if (response.meta != null) {
          if (page >= (response.meta?.totalPage ?? 1)) {
            isNotificationMoreLode.value = false;
          }
        } else {
          isNotificationMoreLode.value = false;
        }
      } else {
        isNotificationMoreLode.value = false;
      }
    } catch (e) {
      appLog("Error fetching notifications: $e");
    } finally {
      isNotificationLoding.value = false;
    }
  }

  void refreshNotification() async {
    page = 1;
    isNotificationMoreLode.value = true;
    notificationList.clear();
    await fetchNorification();
  }

  void _scrollNotification() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      if (isNotificationMoreLode.value && !isNotificationLoding.value) {
        page++;
        fetchNorification();
      }
    }
  }
}
