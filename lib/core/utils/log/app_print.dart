import 'dart:developer';
import 'package:flutter/foundation.dart';

class AppPrint {
  AppPrint._();

  /// Print API response data
  static void apiResponse(String message) {
    if (kDebugMode) {
      log(message);
    }
  }
}
