// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class ShortsScontroller extends GetxController {
//   late VideoPlayerController _videoPlayerController;
//   VideoPlayerController get videoPlayerController => _videoPlayerController;

//   bool _isPlaying = false;
//   bool get isPlaying => _isPlaying;

//   bool _isLoading = true;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   @override
//   void onInit() {
//     super.onInit();
//     printInfo(info: 'ShortsScontroller initialized');
//     _initializeVideo();
//   }

//   void _initializeVideo() {
//     _videoPlayerController = VideoPlayerController.network(
//       'https://cdn.pixabay.com/video/2025/08/20/298643_tiny.mp4',
//     );

//     _videoPlayerController
//         .initialize()
//         .then((_) {
//           _isLoading = false;
//           _hasError = false;
//           // Auto-play the video
//           _videoPlayerController.play();
//           _isPlaying = true;
//           update();
//         })
//         .catchError((error) {
//           _isLoading = false;
//           _hasError = true;
//           update();
//         });

//     // Listen for video completion
//     _videoPlayerController.addListener(_videoListener);
//   }

//   void _videoListener() {
//     if (_videoPlayerController.value.position >=
//         _videoPlayerController.value.duration) {
//       // Video completed, restart
//       _videoPlayerController.seekTo(Duration.zero);
//       _videoPlayerController.play();
//     }
//   }

//   void togglePlayPause() {
//     if (_videoPlayerController.value.isInitialized) {
//       if (_isPlaying) {
//         _videoPlayerController.pause();
//         _isPlaying = false;
//       } else {
//         _videoPlayerController.play();
//         _isPlaying = true;
//       }
//       update();
//     }
//   }

//   void seekTo(Duration position) {
//     if (_videoPlayerController.value.isInitialized) {
//       _videoPlayerController.seekTo(position);
//     }
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.removeListener(_videoListener);
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
// }
