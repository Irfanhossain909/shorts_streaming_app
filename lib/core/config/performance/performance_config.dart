import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Performance configuration and monitoring utilities
class PerformanceConfig {
  PerformanceConfig._();

  /// Initialize performance optimizations
  static void init() {
    if (kDebugMode) {
      // Enable performance overlay in debug mode
      // debugPaintSizeEnabled = false;
      // debugPaintBaselinesEnabled = false;
      // debugPaintPointersEnabled = false;
      // debugPaintLayerBordersEnabled = false;
      // debugRepaintRainbowEnabled = false;
    }

    // Set frame callback priority
    SchedulerBinding.instance.schedulerPhase;

    // Optimize rendering
    debugProfilePaintsEnabled = false;

    if (!kDebugMode) {
      // Disable debug checks in release mode
      debugCheckIntrinsicSizes = false;
    }
  }

  /// Check current FPS
  static double getCurrentFPS() {
    final frameTime = SchedulerBinding.instance.currentFrameTimeStamp;
    if (frameTime == Duration.zero) return 0.0;
    return 1000000.0 / frameTime.inMicroseconds;
  }

  /// Log performance warnings
  static void logPerformanceWarning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ Performance Warning: $message');
    }
  }

  /// Recommended constants for smooth performance
  static const int targetFPS = 60;
  static const Duration targetFrameTime = Duration(milliseconds: 16); // ~60 FPS
  static const int maxListCacheExtent = 500;
  static const int imageMemoryCacheSize = 100;
}

/// Extension for performance optimization helpers
extension PerformanceOptimizations on Widget {
  /// Wrap widget with RepaintBoundary for performance
  Widget withRepaintBoundary() {
    return RepaintBoundary(child: this);
  }

  /// Add performance key for better widget tracking
  Widget withPerformanceKey(String keyName) {
    return KeyedSubtree(key: ValueKey(keyName), child: this);
  }
}
