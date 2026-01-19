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
