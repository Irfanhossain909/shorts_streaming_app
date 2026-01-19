import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';

import '../data/model/notification_model.dart';

class NotificationRepository {
  NotificationRepository._();

  static final NotificationRepository _instance = NotificationRepository._();
  static NotificationRepository get instance => _instance;

  ApiService apiService = ApiService.instance;

  Future<NotificationModel> getNotifications({
    required String page,
    required String limit,
  }) async {
    try {
      final response = await apiService.get(
        ApiEndPoint.instance.notifications,
        queryParameters: {"page": page, "limit": limit},
      );

      if (response.data != null) {
        return NotificationModel.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      }
    } catch (e) {
      errorLog(e);
      rethrow;
    }
  }
}
