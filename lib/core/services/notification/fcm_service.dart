// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
// import 'package:loyalty_customer/service/push_notification/notification_service.dart';
// import 'package:loyalty_customer/widget/app_log/app_print.dart';

// class FCMService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;

//   /// Initialize FCM service
//   static Future<void> initialize() async {
//     try {
//       // Request permission for notifications
//       await _requestPermission();

//       // Get and display FCM token
//       await getToken();

//       // Setup message handlers
//       _setupMessageHandlers();

//       // Check if app was opened from a notification (terminated state)
//       await _checkInitialMessage();

//       debugPrint('✅ FCM Service initialized');
//     } catch (e) {
//       debugPrint('❌ FCM Service initialization error: $e');
//     }
//   }

//   /// Request notification permissions (iOS/Android)
//   static Future<void> _requestPermission() async {
//     try {
//       NotificationSettings settings = await _firebaseMessaging
//           .requestPermission(
//             alert: true,
//             badge: true,
//             sound: true,
//             provisional: false,
//             announcement: false,
//             carPlay: false,
//             criticalAlert: false,
//           );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         debugPrint('✅ Notification permission granted');
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         debugPrint('⚠️ Notification permission provisional');
//       } else {
//         debugPrint('❌ Notification permission denied');
//       }
//     } catch (e) {
//       debugPrint('❌ Permission request error: $e');
//     }
//   }

//   /// Get FCM token
//   static Future<String?> getToken() async {
//     try {
//       String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         debugPrint('📱 FCM Token: $token');
//         await GetStorageServices.instance.setFCMtoken(token);
//         AppPrint.appPrint(
//           "Get FCM Token: ${GetStorageServices.instance.getFCMtoken()}",
//         );
//         // Listen for token refresh
//         _firebaseMessaging.onTokenRefresh.listen((newToken) {
//           debugPrint('🔄 FCM Token refreshed: $newToken');
//           // TODO: Send updated token to your backend
//         });

//         return token;
//       }
//     } catch (e) {
//       debugPrint('❌ Get token error: $e');
//     }
//     return null;
//   }

//   /// Delete FCM token (call on user logout)
//   static Future<void> deleteToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//       debugPrint('✅ FCM Token deleted');
//     } catch (e) {
//       debugPrint('❌ Delete token error: $e');
//     }
//   }

//   /// Setup message handlers for different app states
//   static void _setupMessageHandlers() {
//     // Foreground messages (app is open and visible)
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Background messages (app is minimized, user taps notification)
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
//   }

//   /// Handle foreground messages (app is open)
//   static void _handleForegroundMessage(RemoteMessage message) {
//     debugPrint('📬 Foreground Message Received');
//     debugPrint('Title: ${message.notification?.title}');
//     debugPrint('Body: ${message.notification?.body}');
//     debugPrint('Data: ${message.data}');

//     // Show local notification when app is in foreground
//     NotificationService.showNotification({
//       'message': message.notification?.title ?? 'New Message',
//       'type': message.notification?.body ?? '',
//       'data': message.data,
//     });
//   }

//   /// Handle notification opened (app was in background)
//   static void _handleMessageOpenedApp(RemoteMessage message) {
//     debugPrint('🔔 Notification Opened');
//     debugPrint('Title: ${message.notification?.title}');
//     debugPrint('Body: ${message.notification?.body}');
//     debugPrint('Data: ${message.data}');

//     // TODO: Navigate to specific screen based on notification data
//     // Example:
//     // final data = message.data;
//     // if (data['type'] == 'order') {
//     //   Get.toNamed('/order-details', arguments: {'orderId': data['orderId']});
//     // } else if (data['type'] == 'chat') {
//     //   Get.toNamed('/chat', arguments: {'chatId': data['chatId']});
//     // }
//   }

//   /// Check for initial message (app opened from terminated state)
//   static Future<void> _checkInitialMessage() async {
//     try {
//       RemoteMessage? initialMessage = await _firebaseMessaging
//           .getInitialMessage();

//       if (initialMessage != null) {
//         debugPrint('🚀 App opened from terminated state');
//         debugPrint('Title: ${initialMessage.notification?.title}');
//         debugPrint('Body: ${initialMessage.notification?.body}');
//         debugPrint('Data: ${initialMessage.data}');

//         // Handle the notification
//         _handleMessageOpenedApp(initialMessage);
//       }
//     } catch (e) {
//       debugPrint('❌ Check initial message error: $e');
//     }
//   }

//   /// Subscribe to a topic
//   static Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _firebaseMessaging.subscribeToTopic(topic);
//       debugPrint('✅ Subscribed to topic: $topic');
//     } catch (e) {
//       debugPrint('❌ Subscribe to topic error: $e');
//     }
//   }

//   /// Unsubscribe from a topic
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _firebaseMessaging.unsubscribeFromTopic(topic);
//       debugPrint('✅ Unsubscribed from topic: $topic');
//     } catch (e) {
//       debugPrint('❌ Unsubscribe from topic error: $e');
//     }
//   }

//   /// Get notification settings
//   static Future<NotificationSettings> getNotificationSettings() async {
//     return await _firebaseMessaging.getNotificationSettings();
//   }

//   /// iOS only: Get APNS token
//   static Future<String?> getAPNSToken() async {
//     return await _firebaseMessaging.getAPNSToken();
//   }
// }
