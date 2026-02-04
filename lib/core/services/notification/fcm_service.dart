import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../storage/storage_services.dart';
import '../storage/storage_keys.dart';
import '../../utils/log/app_log.dart';
import 'notification_service.dart';

/// Firebase Cloud Messaging service: token, permissions, foreground/background/terminated handling.
class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// True when running on Android or iOS (not web). Use before initializing FCM.
  static bool get isSupportedDevice {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Initialize FCM: request permission, get token, setup handlers, check initial message.
  /// Call only after [Firebase.initializeApp]. No-op on web.
  static Future<void> initialize() async {
    if (!isSupportedDevice) {
      if (kDebugMode) {
        debugPrint('⏭️ FCM skipped: not Android/iOS (e.g. web)');
      }
      return;
    }
    try {
      await _requestPermission();
      await getToken();
      _setupMessageHandlers();
      await _checkInitialMessage();
      if (kDebugMode) {
        debugPrint('✅ FCM Service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ FCM Service initialization error: $e');
      }
    }
  }

  /// Request notification permissions (iOS/Android, including Android 13+).
  static Future<void> _requestPermission() async {
    try {
      final NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
            announcement: false,
            carPlay: false,
            criticalAlert: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) debugPrint('✅ Notification permission granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) debugPrint('⚠️ Notification permission provisional');
      } else {
        if (kDebugMode) debugPrint('❌ Notification permission denied');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Permission request error: $e');
    }
  }

  /// Get FCM token and save to local storage. Returns null on failure.
  static Future<String?> getToken() async {
    if (!isSupportedDevice) return null;
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        if (kDebugMode) debugPrint('📱 FCM Token: $token');
        await LocalStorage.setString(LocalStorageKeys.fcmToken, token);
        LocalStorage.fcmToken = token;
        appLog('FCM Token: ${LocalStorage.fcmToken}', source: 'FCM');
        _firebaseMessaging.onTokenRefresh.listen((String newToken) {
          if (kDebugMode) debugPrint('🔄 FCM Token refreshed: $newToken');
          LocalStorage.setString(LocalStorageKeys.fcmToken, newToken);
          LocalStorage.fcmToken = newToken;
        });
        return token;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Get token error: $e');
    }
    return null;
  }

  /// Delete FCM token (e.g. on logout).
  static Future<void> deleteToken() async {
    if (!isSupportedDevice) return;
    try {
      await _firebaseMessaging.deleteToken();
      await LocalStorage.setString(LocalStorageKeys.fcmToken, '');
      LocalStorage.fcmToken = '';
      if (kDebugMode) debugPrint('✅ FCM Token deleted');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Delete token error: $e');
    }
  }

  static void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }
  static void _handleForegroundMessage(RemoteMessage message) {
  if (kDebugMode) {
    debugPrint('📬 Foreground Message Received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');
  }

  NotificationService.showNotification(
    title: message.notification?.title ?? 'New Message',
    body: message.notification?.body ?? '',
    data: message.data,
  );
}

  

  // static void _handleForegroundMessage(RemoteMessage message) {
  //   if (kDebugMode) {
  //     debugPrint('📬 Foreground Message Received');
  //     debugPrint('Title: ${message.notification?.title}');
  //     debugPrint('Body: ${message.notification?.body}');
  //     debugPrint('Data: ${message.data}');
  //   }
  //   NotificationService.showNotification({
  //     'message': message.notification?.title ?? 'New Message',
  //     'type': message.notification?.body ?? '',
  //     'data': message.data,
  //   });
  // }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('🔔 Notification Opened');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
    }
    // TODO: Navigate based on message.data (e.g. type, orderId, chatId)
  }

  static Future<void> _checkInitialMessage() async {
    try {
      final RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) {
          debugPrint('🚀 App opened from terminated state');
          debugPrint('Title: ${initialMessage.notification?.title}');
          debugPrint('Body: ${initialMessage.notification?.body}');
          debugPrint('Data: ${initialMessage.data}');
        }
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Check initial message error: $e');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (!isSupportedDevice) return;
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Subscribe to topic error: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (!isSupportedDevice) return;
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Unsubscribe from topic error: $e');
    }
  }

  static Future<NotificationSettings> getNotificationSettings() async {
    return _firebaseMessaging.getNotificationSettings();
  }

  static Future<String?> getAPNSToken() async {
    if (!isSupportedDevice) return null;
    return _firebaseMessaging.getAPNSToken();
  }
}
