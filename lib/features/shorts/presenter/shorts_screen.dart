import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/shorts/widgets/episod_list_bottomsheet.dart';
import 'package:testemu/features/shorts/widgets/reel_button.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class ShortsFeedScreen extends StatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  State<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends State<ShortsFeedScreen> {
  final List<String> videos = [
    "https://cdn.pixabay.com/video/2025/04/29/275498_tiny.mp4",
    "https://cdn.pixabay.com/video/2025/08/18/298103_tiny.mp4",
    "https://cdn.pixabay.com/video/2025/08/20/298643_tiny.mp4",
    "https://cdn.pixabay.com/video/2025/08/12/296958_tiny.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return ShortVideoPlayer(videoUrl: videos[index]);
        },
      ),
    );
  }
}

class ShortVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const ShortVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<ShortVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize()
          .then((_) {
            setState(() {
              _isLoading = false;
              _hasError = false;
            });
            _controller.play();
            _controller.setLooping(true);
            _isPlaying = true;
          })
          .catchError((e) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          });
  }

  void _togglePlayPause() {
    if (_controller.value.isInitialized) {
      setState(() {
        if (_isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        _isPlaying = !_isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Background video
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? const Center(
                  child: Text(
                    "Error loading video",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),

          /// Play icon overlay
          if (!_isPlaying && !_isLoading && !_hasError)
            const Icon(Icons.play_arrow, size: 64, color: Colors.white),

          /// 🔥 Gradient Shadow from bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 550.h, // তোমার চাওয়া অনুযায়ী
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: .8), // নিচে গাঢ়
                    Colors.black.withValues(alpha: .5), // মাঝামাঝি
                    Colors.transparent, // ওপরে transparent
                  ],
                ),
              ),
            ),
          ),

          /// Texts + Progress bar
          if (!_isLoading && !_hasError)
            Positioned(
              bottom: 110.h,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "This is the title of the content",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: AppColors.background,
                  ),
                  SizedBox(
                    width: 300.w,
                    child: CommonText(
                      fontSize: 12.sp,
                      color: AppColors.background.withValues(alpha: 0.7),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      text:
                          "This is the description text. It is long and should be shown only in 2 lines initially. When the user clicks 'See more', the full description will be displayed properly without cutting off any part of the text.",
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Row(
                    children: [
                      CommonImage(imageSrc: AppImages.listIc, width: 16),
                      const SizedBox(width: 8),
                      CommonText(
                        text: "EP.1/67 EP",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: AppColors.red2,
                        bufferedColor: Colors.grey.withValues(alpha: .5),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// Right side action buttons
          Positioned(
            bottom: 146.h,
            right: 10,
            child: Column(
              spacing: 16.h,
              children: [
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      ListBottomSheet(),
                    );
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: CommonImage(
                        fill: BoxFit.cover,
                        imageSrc:
                            "https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg",
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ),
                ),
                ReelButton(imgPath: AppImages.star, text: "125.5K"),
                ReelButton(
                  imgPath: AppImages.listIc,
                  text: "List",
                  onTap: () {
                    // Get.bottomSheet(
                    //   isScrollControlled: true,
                    //   ListBottomSheet(),
                    // );
                  },
                ),
                ReelButton(imgPath: AppImages.shareIc, text: "Share"),
                ReelButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.downloadMenu);
                  },
                  imgPath: AppImages.download,
                  text: "DownLoad",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
