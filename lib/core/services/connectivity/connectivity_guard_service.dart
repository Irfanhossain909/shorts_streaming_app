import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';

/// Shows [AppRoutes.noInternet] when the device loses network interfaces and
/// closes it when connectivity returns — no manual "Try Again" required.
class ConnectivityGuardService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _onlineConfirmTimer;

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) => _attach());
  }

  void _attach() {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(_apply);
    unawaited(
      _connectivity.checkConnectivity().then(_apply).catchError((_) {}),
    );
  }

  void _apply(List<ConnectivityResult> results) {
    final online = _hasConnection(results);
    if (online) {
      _scheduleDismissNoInternet();
    } else {
      _onlineConfirmTimer?.cancel();
      _onlineConfirmTimer = null;
      _showNoInternet();
    }
  }

  static bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  void _showNoInternet() {
    _runAfterFrame(() {
      if (Get.currentRoute != AppRoutes.noInternet) {
        Get.toNamed(AppRoutes.noInternet);
      }
    });
  }

  /// Waits briefly so fast flaps don't open / close the screen repeatedly.
  void _scheduleDismissNoInternet() {
    _onlineConfirmTimer?.cancel();
    _onlineConfirmTimer = Timer(const Duration(milliseconds: 450), () {
      _runAfterFrame(() {
        if (Get.currentRoute != AppRoutes.noInternet) return;
        if (Get.key.currentContext == null) return;
        final nav = Get.key.currentState;
        if (nav != null && nav.canPop()) {
          Get.back();
        }
      });
    });
  }

  void _runAfterFrame(VoidCallback action) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.key.currentContext != null) {
        action();
      }
    });
  }

  @override
  void onClose() {
    _onlineConfirmTimer?.cancel();
    _subscription?.cancel();
    super.onClose();
  }
}
