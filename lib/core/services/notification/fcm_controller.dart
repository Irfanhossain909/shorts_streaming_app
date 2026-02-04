import 'package:get/get.dart';

import 'fcm_service.dart';

/// GetX controller for FCM token and topic subscription (UI-friendly).
class FCMController extends GetxController {
  final Rxn<String> fcmToken = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    if (!FCMService.isSupportedDevice) return;
    final String? token = await FCMService.getToken();
    if (token != null) {
      fcmToken.value = token;
    }
  }

  Future<void> refreshToken() async {
    final String? token = await FCMService.getToken();
    if (token != null) {
      fcmToken.value = token;
    }
  }

  Future<void> deleteToken() async {
    await FCMService.deleteToken();
    fcmToken.value = null;
  }

  Future<void> subscribeToTopic(String topic) async {
    await FCMService.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FCMService.unsubscribeFromTopic(topic);
  }

  String? get currentToken => fcmToken.value;

  bool get hasToken => fcmToken.value != null;
}
