import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

import 'app.dart';
import 'core/config/dependency/dependency_injection.dart';
import 'core/config/performance/performance_config.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/notification/fcm_service.dart';
import 'core/services/notification/notification_service.dart';
import 'core/services/storage/storage_services.dart';
import 'firebase_options.dart';

/// 🔥 Top-level background message handler
/// This MUST be a top-level function (not inside a class)
/// Called when app receives notification in terminated/background state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('📩 Background Message Received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
}

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase & FCM: init first so FCM is ready before app UI
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Performance optimizations
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  PerformanceConfig.init();

  await init.tryCatch();

  // Device check: init push notifications only on Android/iOS (not web)
  if (FCMService.isSupportedDevice) {
    await NotificationService.init();
    await FCMService.initialize();
  }

  await DeepLinkService.instance.initialize();

  runApp(const MyApp());
}

init() async {
  DependencyInjection dI = DependencyInjection();
  dI.dependencies();

  // // Move socket connection to background to avoid blocking main thread
  // Future.delayed(const Duration(milliseconds: 500), () {
  //   SocketAllOparations.instance.initializeSocket();
  // });

  await Future.wait([
    LocalStorage.getAllPrefData(),
    dotenv.load(fileName: ".env"),
  ]);
}
