import 'package:flutter/material.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_images.dart';
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
      // appBar: AppBar(
      //   toolbarHeight: 88,
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: Container(
      //       decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         color: AppColors.red2, // Background color
      //       ),
      //       padding: EdgeInsets.all(8), // Size control
      //       child: Icon(Icons.arrow_back, color: Colors.white),
      //     ),
      //   ),
      // ),
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

          // Play icon overlay
          if (!_isPlaying && !_isLoading && !_hasError)
            const Icon(Icons.play_arrow, size: 64, color: Colors.white),

          // Progress bar
          if (!_isLoading && !_hasError)
            Positioned(
              bottom: 130.h,
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
                        bufferedColor: Colors.grey.withOpacity(0.5),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Positioned(
            bottom: 173.h,
            right: 10,
            child: Column(
              spacing: 16.h,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.background, width: 1.w),
                  ),

                  child: CommonImage(
                    size: 46.w,
                    fill: BoxFit.cover,
                    imageSrc:
                        "https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg",
                    width: 40,
                    height: 40,
                    borderRadius: 20,
                  ),
                ),
                ReelButton(imgPath: AppImages.star, text: "125.5K"),
                ReelButton(imgPath: AppImages.listIc, text: "List"),
                ReelButton(imgPath: AppImages.shareIc, text: "Share"),
                ReelButton(imgPath: AppImages.download, text: "DownLoad"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
