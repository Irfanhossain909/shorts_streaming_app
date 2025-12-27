import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

import 'app.dart';
import 'core/config/dependency/dependency_injection.dart';
import 'core/services/socket/socket_service.dart';
import 'core/services/storage/storage_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init.tryCatch();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

init() async {
  DependencyInjection dI = DependencyInjection();
  dI.dependencies();
  SocketServices.connectToSocket();

  await Future.wait([
    LocalStorage.getAllPrefData(),
    // NotificationService.initLocalNotification(),
    dotenv.load(fileName: ".env"),
  ]);
}
