import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 🔹 Call this from main()
  static Future<void> init() async {
    await _initLocalNotification();
    await _initFirebaseNotification();
  }

  /// ---------------- LOCAL NOTIFICATION ----------------
  static Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createAndroidChannel();

    debugPrint('✅ Local notification initialized');
  }

  static Future<void> _createAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// ---------------- FIREBASE NOTIFICATION ----------------
  static Future<void> _initFirebaseNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// 🔹 iOS permission (MANDATORY)
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// 🔹 Foreground notification allow (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Foreground message handled by FCMService - avoid duplicate notification
    debugPrint('✅ Firebase notification initialized');
  }

  /// ---------------- SHOW LOCAL NOTIFICATION ----------------
  static Future<void> showNotification({
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  title: title ?? 'New Notification',
  body: body ?? '',
  notificationDetails: details,
  payload: data?.toString(),
);


    debugPrint('📬 Local notification shown');
  }

  /// ---------------- TAP HANDLER ----------------
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
  }
}



// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// /// Local notification display for foreground FCM messages.
// /// Handles Android notification channel and iOS permission.
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   /// Initialize local notifications (call after WidgetsBinding, e.g. in main).
//   static Future<void> initLocalNotification() async {
//     try {
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       const DarwinInitializationSettings iosSettings =
//           DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );

//       const InitializationSettings initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       await _notifications.initialize(
//         settings: initSettings,
//         onDidReceiveNotificationResponse: _onNotificationTapped,
//       );

//       await _createAndroidNotificationChannel();

//       if (kDebugMode) {
//         debugPrint('✅ Notification Service initialized');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('❌ Notification Service Error: $e');
//       }
//     }
//   }

//   static Future<void> _createAndroidNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//       enableVibration: true,
//       playSound: true,
//     );

//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   /// Show local notification (e.g. when FCM message received in foreground).
//   static Future<void> showNotification(Map<String, dynamic> payload) async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'high_importance_channel',
//         'High Importance Notifications',
//         channelDescription:
//             'This channel is used for important notifications.',
//         importance: Importance.high,
//         priority: Priority.high,
//         enableVibration: true,
//         playSound: true,
//         icon: '@mipmap/ic_launcher',
//       );

//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       final String title = payload['message']?.toString() ?? 'New Notification';
//       final String body = payload['type']?.toString() ?? '';
//       final String? payloadStr = payload['data'] != null
//           ? payload['data'].toString()
//           : null;

//       await _notifications.show(
//         id: id,
//         title: title,
//         body: body,
//         notificationDetails: notificationDetails,
//         payload: payloadStr,
//       );

//       if (kDebugMode) {
//         debugPrint('📬 Local notification shown');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('❌ Show notification error: $e');
//       }
//     }
//   }

//   static void _onNotificationTapped(NotificationResponse response) {
//     if (kDebugMode) {
//       debugPrint('🔔 Notification tapped: ${response.payload}');
//     }
//     // TODO: Navigate based on payload if needed
//   }
// }
