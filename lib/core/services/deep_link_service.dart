import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  static DeepLinkService get instance => _instance;

  late AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  /// Initialize deep link listener
  Future<void> initialize() async {
    _appLinks = AppLinks();

    // Handle initial deep link when app is launched from a link
    await _handleInitialLink();

    // Listen for deep links while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri.toString());
      },
      onError: (err) {
        if (kDebugMode) {
          print('Deep Link Error: $err');
        }
      },
    );
  }

  /// Handle initial link when app is opened from a deep link
  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        // Delay to ensure the app is fully initialized
        await Future.delayed(const Duration(milliseconds: 500));
        _handleDeepLink(uri.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling initial link: $e');
      }
    }
  }

  /// Parse and handle deep link
  void _handleDeepLink(String link) {
    try {
      final uri = Uri.parse(link);

      if (kDebugMode) {
        print('📱 Deep Link Received: $link');
        print('🔗 Scheme: ${uri.scheme}');
        print('🔗 Host: ${uri.host}');
        print('🔗 Path: ${uri.path}');
        print('🔗 Segments: ${uri.pathSegments}');
      }

      // Handle different deep link patterns
      // Pattern 1: creepyshorts://shorts/:videoId
      // Pattern 2: https://api.creepy-shorts.com/shorts/:videoId

      if (uri.pathSegments.isNotEmpty) {
        final firstSegment = uri.pathSegments[0];

        // Navigate to Shorts screen with specific video
        if (firstSegment == 'shorts' && uri.pathSegments.length >= 2) {
          final videoId = uri.pathSegments[1];
          _navigateToShortsVideo(videoId);
        }
        // Add more route patterns here as needed
        // Example: if (firstSegment == 'movie' && uri.pathSegments.length >= 2) { ... }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parsing deep link: $e');
      }
    }
  }

  /// Navigate to specific shorts video
  void _navigateToShortsVideo(String videoId) {
    if (kDebugMode) {
      print('🎬 Navigating to shorts video: $videoId');
    }

    // Navigate to shorts screen
    // The shorts controller will handle finding and playing the specific video
    Get.toNamed(AppRoutes.shorts, arguments: {'videoId': videoId});

    // Show a loading indicator or success message
    Get.snackbar(
      '🎬 Opening Video',
      'Loading your video...',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Dispose the service
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}
