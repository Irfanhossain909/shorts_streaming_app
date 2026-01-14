import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

import 'app.dart';
import 'core/config/dependency/dependency_injection.dart';
import 'core/config/performance/performance_config.dart';
import 'core/services/socket/socket_service.dart';
import 'core/services/storage/storage_services.dart';

Future<void> main() async {
  //debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  PerformanceConfig.init();

  await init.tryCatch();
  runApp(
    const MyApp(), // Wrap your app
  );
}

init() async {
  DependencyInjection dI = DependencyInjection();
  dI.dependencies();

  // Move socket connection to background to avoid blocking main thread
  Future.delayed(const Duration(milliseconds: 500), () {
    SocketServices.connectToSocket();
  });

  await Future.wait([
    LocalStorage.getAllPrefData(),
    // NotificationService.initLocalNotification(),
    dotenv.load(fileName: ".env"),
  ]);
}
