import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

class AdOverlayWidget extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onVideoFinished;
  final RxBool canClose;
  final RxBool isLoading;
  final RxString videoUrl;

  const AdOverlayWidget({
    super.key,
    required this.onClose,
    required this.onVideoFinished,
    required this.canClose,
    required this.isLoading,
    required this.videoUrl,
  });

  @override
  State<AdOverlayWidget> createState() => _AdOverlayWidgetState();
}

class _AdOverlayWidgetState extends State<AdOverlayWidget> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    ever(widget.videoUrl, (url) {
      if (url.isNotEmpty) {
        _initializeVideo(url);
      }
    });
    if (widget.videoUrl.value.isNotEmpty) {
      _initializeVideo(widget.videoUrl.value);
    }
  }

  Future<void> _initializeVideo(String url) async {
    if (_isInitializing) return;
    _isInitializing = true;

    await _disposeController();

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );
    _controller = controller;

    try {
      await controller.initialize();

      if (!mounted || _controller != controller) {
        controller.dispose();
        return;
      }

      controller.addListener(_onVideoUpdate);
      controller.play();

      setState(() {
        _isVideoInitialized = true;
        _hasError = false;
      });
    } catch (e) {
      debugPrint('Ad video init error: $e');
      if (mounted && _controller == controller) {
        setState(() {
          _hasError = true;
          _isVideoInitialized = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onClose();
        });
      }
    } finally {
      _isInitializing = false;
    }
  }

  void _onVideoUpdate() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    final position = c.value.position;
    final duration = c.value.duration;

    if (duration.inMilliseconds > 0 &&
        position.inMilliseconds >= duration.inMilliseconds - 200) {
      c.removeListener(_onVideoUpdate);
      c.pause();
      widget.onVideoFinished();
    }
  }

  Future<void> _disposeController() async {
    final old = _controller;
    _controller = null;
    if (old != null) {
      old.removeListener(_onVideoUpdate);
      try {
        await old.pause();
        await old.dispose();
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _isVideoInitialized = false;
        _hasError = false;
      });
    }
  }

  @override
  void dispose() {
    final c = _controller;
    _controller = null;
    if (c != null) {
      c.removeListener(_onVideoUpdate);
      c.pause().then((_) => c.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Video / Loading / Error content
            Center(
              child: Obx(() {
                if (widget.isLoading.value || !_isVideoInitialized) {
                  return _buildLoadingState();
                }
                if (_hasError) {
                  return _buildErrorState();
                }
                return _buildVideoPlayer();
              }),
            ),

            // "Ad" badge top-left
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Ad',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: .8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Countdown / Close button top-right
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: Obx(() {
                if (widget.canClose.value) {
                  return _buildCloseButton();
                }
                if (_isVideoInitialized && _controller != null) {
                  return _buildCountdown();
                }
                return const SizedBox.shrink();
              }),
            ),

            // Video progress bar at bottom
            if (_isVideoInitialized && _controller != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: false,
                  colors: VideoProgressColors(
                    playedColor: AppColors.red2,
                    bufferedColor: AppColors.white.withValues(alpha: .3),
                    backgroundColor: AppColors.white.withValues(alpha: .1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48.w,
          height: 48.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Loading ad...',
          style: TextStyle(
            color: AppColors.white.withValues(alpha: .6),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 48.w,
          color: AppColors.white.withValues(alpha: .5),
        ),
        SizedBox(height: 12.h),
        Text(
          'Ad unavailable',
          style: TextStyle(
            color: AppColors.white.withValues(alpha: .6),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    final c = _controller!;
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: c.value.size.width,
          height: c.value.size.height,
          child: VideoPlayer(c),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller!,
      builder: (context, value, _) {
        final remaining = value.duration - value.position;
        final secs = remaining.inSeconds.clamp(0, 9999);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Skip in ${secs}s',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: .8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: AppColors.white,
          size: 20.w,
        ),
      ),
    );
  }
}
