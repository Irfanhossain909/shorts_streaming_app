// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   /// Initialize local notifications
//   static Future<void> initLocalNotification() async {
//     try {
//       // Android initialization settings
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       // iOS initialization settings
//       const DarwinInitializationSettings iosSettings =
//           DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//           );

//       // Combined initialization settings
//       const InitializationSettings initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       // Initialize the plugin
//       await _notifications.initialize(
//         initSettings,
//         onDidReceiveNotificationResponse: _onNotificationTapped,
//       );

//       // Create Android notification channel
//       await _createAndroidNotificationChannel();

//       debugPrint('✅ Notification Service initialized');
//     } catch (e) {
//       debugPrint('❌ Notification Service Error: $e');
//     }
//   }

//   /// Create Android notification channel
//   static Future<void> _createAndroidNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // Must match AndroidManifest.xml
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//       enableVibration: true,
//       playSound: true,
//     );

//     await _notifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   /// Show local notification
//   static Future<void> showNotification(Map<String, dynamic> payload) async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription:
//                 'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//             icon: '@mipmap/ic_launcher',
//           );

//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       await _notifications.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique notification ID
//         payload['message'] ?? 'New Notification',
//         payload['type'] ?? '',
//         notificationDetails,
//         payload: payload['data'].toString(),
//       );

//       debugPrint('📬 Local notification shown');
//     } catch (e) {
//       debugPrint('❌ Show notification error: $e');
//     }
//   }

//   /// Handle notification tap
//   static void _onNotificationTapped(NotificationResponse response) {
//     debugPrint('🔔 Notification tapped: ${response.payload}');
//     // TODO: Add navigation logic based on payload
//   }
// }
