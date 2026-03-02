import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';

import '../data/model/notification_model.dart';

class NotificationRepository {
  NotificationRepository._();

  static final NotificationRepository _instance = NotificationRepository._();
  static NotificationRepository get instance => _instance;

  ApiService apiService = ApiService.instance;

  Future<bool> updateFCMToken() async {
    try {
      if (LocalStorage.fcmToken.isEmpty || LocalStorage.deviceId.isEmpty) {
        return false;
      }
      final response = await apiService.post(
        ApiEndPoint.instance.updateFCMToken,
        body: {
          "fcmToken": LocalStorage.fcmToken,
          "deviceId": LocalStorage.deviceId,
          "deviceType": LocalStorage.deviceType,
        },
      );
      if (response.isSuccess) {
        return true;
      }
    } catch (e) {
      errorLog(e);
      rethrow;
    }
    return false;
  }

  Future<NotificationModel> getNotifications({
    required String page,
    required String limit,
  }) async {
    try {
      final response = await apiService.get(
        ApiEndPoint.instance.notifications,
        queryParameters: {"page": page, "limit": limit},
      );
      appLog(response);
      return NotificationModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } catch (e) {
      errorLog(e);
      rethrow;
    }
  }

  Future<bool> readNotification({required String notificationId}) async {
    try {
      final response = await apiService.patch(
        ApiEndPoint.instance.readNotification(notificationId: notificationId),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog(e);
      rethrow;
    }
    return false;
  }

  Future<bool> readAllNotification() async {
    try {
      final response = await apiService.patch(
        ApiEndPoint.instance.notifications,
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog(e);
      rethrow;
    }
    return false;
  }
}
