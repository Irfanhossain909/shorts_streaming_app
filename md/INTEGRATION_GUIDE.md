# Integration Guide - Offline Download Feature

## Quick Start

### Step 1: Add Navigation Button to Download Menu

Update your existing `DownloadMenuScreen` to include a button for "Downloaded Shorts":

```dart
// In lib/features/download/presenter/download_menu_screen.dart

import 'package:testemu/core/config/route/app_routes.dart';

// Add this button in your menu
InkWell(
  onTap: () {
    Get.toNamed(AppRoutes.downloadedShorts);
  },
  child: Container(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        Icon(Icons.video_library, color: AppColors.white),
        SizedBox(width: 12),
        CommonText(
          text: "Downloaded Shorts",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.white),
      ],
    ),
  ),
),
```

### Step 2: Update Shorts Screen Download Button

The download button is already updated in `shorts_screen.dart` at line 194:

```dart
ReelButton(
  onTap: () => controller.downloadCurrentVideo(),
  imgPath: AppImages.download,
  text: "Download",
),
```

This button will:
- Download the current video
- Save metadata to SharedPreferences
- Show success/error messages
- Prevent duplicate downloads

### Step 3: Test the Feature

1. Run the app:
```bash
flutter run
```

2. Navigate to Shorts screen
3. Click the Download button on any video
4. Go to Download Menu → Downloaded Shorts
5. See your downloaded videos
6. Tap any video to play offline

## Adding to Navigation Bar

If you want to add quick access from the bottom navigation bar:

```dart
// In lib/features/navigation_bar/presentation/screen/navigation_screen.dart

// Add a long-press handler to the profile or download tab
InkWell(
  onTap: () => controller.changeIndex(index),
  onLongPress: () {
    if (index == 2) { // Downloads tab
      Get.toNamed(AppRoutes.downloadedShorts);
    }
  },
  // ... rest of your navigation code
),
```

## Adding to Profile Screen

Add a menu item in your profile screen:

```dart
// In lib/features/profile/presentation/screen/profile_screen.dart

ListTile(
  leading: Icon(Icons.download_for_offline, color: AppColors.white),
  title: CommonText(
    text: "My Downloads",
    fontSize: 16.sp,
    color: AppColors.white,
  ),
  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.white),
  onTap: () {
    Get.toNamed(AppRoutes.downloadedShorts);
  },
),
```

## Adding Download Badge/Counter

Show how many videos are downloaded:

```dart
// Create a controller method to get download count
class DownloadMenuController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;
  RxInt downloadCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchDownloadCount();
  }
  
  Future<void> fetchDownloadCount() async {
    final count = await _downloadService.getDownloadedVideosCount();
    downloadCount.value = count;
  }
}

// In your UI
Obx(() {
  final count = controller.downloadCount.value;
  return Stack(
    children: [
      // Your icon/button
      Icon(Icons.download),
      
      // Badge
      if (count > 0)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ),
    ],
  );
}),
```

## Download from Video Detail Screen

If you have a video detail screen, add download functionality there:

```dart
// In lib/features/shorts/presenter/video_detail_screen.dart

import 'package:testemu/features/download/service/download_service.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';

class VideoDetailController extends GetxController {
  final DownloadService downloadService = DownloadService.instance;
  RxBool isDownloaded = false.obs;
  
  Future<void> checkIfDownloaded(String videoId) async {
    isDownloaded.value = await downloadService.isVideoDownloaded(videoId);
  }
  
  Future<void> toggleDownload(VideoData videoData) async {
    if (isDownloaded.value) {
      // Delete
      await downloadService.deleteDownloadedVideo(videoData.id);
      isDownloaded.value = false;
      Get.snackbar("Removed", "Video removed from downloads");
    } else {
      // Download
      final path = await getVideoLocalPath(videoData.id);
      final success = await downloadVideo(
        url: videoData.videoUrl,
        savePath: path,
      );
      
      if (success) {
        final file = File(path);
        final fileSize = await file.length();
        
        final downloadedVideo = DownloadedVideoModel(
          videoId: videoData.id,
          title: videoData.title,
          description: videoData.description,
          thumbnailUrl: videoData.thumbnail,
          localPath: path,
          originalUrl: videoData.videoUrl,
          downloadedAt: DateTime.now(),
          fileSize: fileSize,
          episodeNumber: videoData.episodeNumber ?? '',
          seasonNumber: videoData.seasonNumber ?? '',
        );
        
        await downloadService.saveDownloadedVideo(downloadedVideo);
        isDownloaded.value = true;
        Get.snackbar("Downloaded", "Video available offline");
      }
    }
  }
}

// In UI
Obx(() => IconButton(
  icon: Icon(
    controller.isDownloaded.value 
      ? Icons.download_done 
      : Icons.download,
    color: AppColors.white,
  ),
  onPressed: () => controller.toggleDownload(videoData),
)),
```

## Storage Management Screen

Add a storage management screen showing detailed statistics:

```dart
// Create lib/features/download/presenter/download_storage_screen.dart

class DownloadStorageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadStorageController>(
      init: DownloadStorageController(),
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(title: "Storage Management"),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Total storage card
                Card(
                  child: ListTile(
                    leading: Icon(Icons.storage),
                    title: Text("Total Storage Used"),
                    subtitle: Obx(() => Text(controller.totalStorage.value)),
                  ),
                ),
                
                // Video count card
                Card(
                  child: ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text("Downloaded Videos"),
                    subtitle: Obx(() => Text("${controller.videoCount.value} videos")),
                  ),
                ),
                
                // Clear all button
                SizedBox(height: 20),
                AppButton(
                  title: "Clear All Downloads",
                  onTap: () => controller.showClearAllDialog(),
                  backgroundColor: AppColors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DownloadStorageController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;
  RxString totalStorage = '0 MB'.obs;
  RxInt videoCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadStats();
  }
  
  Future<void> loadStats() async {
    final bytes = await _downloadService.getTotalStorageUsed();
    totalStorage.value = _downloadService.formatStorageSize(bytes);
    videoCount.value = await _downloadService.getDownloadedVideosCount();
  }
  
  void showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Clear All Downloads?"),
        content: Text("This will delete all downloaded videos and free up ${totalStorage.value}"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _downloadService.clearAllDownloads();
              await loadStats();
              Get.snackbar("Success", "All downloads cleared");
            },
            child: Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
```

## Automatic API Integration

When you have a real API endpoint for video details, replace the hardcoded metadata in `shorts_controller.dart`:

**Current (Demo)**:
```dart
final metadata = index < videoMetadata.length
    ? videoMetadata[index]
    : {...};
```

**Production (with API)**:
```dart
// Fetch from your API
final videoDetails = await repository.getVideoDetails(videoId);

final downloadedVideo = DownloadedVideoModel(
  videoId: videoId,
  title: videoDetails.title,
  description: videoDetails.description,
  thumbnailUrl: videoDetails.thumbnailUrl,
  localPath: path,
  originalUrl: url,
  downloadedAt: DateTime.now(),
  fileSize: fileSize,
  episodeNumber: videoDetails.episodeNumber,
  seasonNumber: videoDetails.seasonNumber,
);
```

## Deep Linking (Optional)

Add deep links to downloaded videos:

```dart
// In app.dart or main.dart
GetMaterialApp(
  // ...
  initialRoute: AppRoutes.splash,
  getPages: AppRoutes.routes,
  
  // Add deep link handler
  unknownRoute: GetPage(
    name: '/not-found',
    page: () => NotFoundScreen(),
  ),
  
  // Handle deep links
  navigatorObservers: [
    DeepLinkObserver(),
  ],
);

// Create deep link handler
class DeepLinkObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // Handle deep link to specific downloaded video
    if (route.settings.name?.contains('downloaded_shorts') ?? false) {
      final videoId = route.settings.arguments as String?;
      if (videoId != null) {
        // Open specific video
      }
    }
  }
}
```

## Notifications (Optional)

Show notification when download completes:

```dart
// Add to downloadCurrentVideo() in shorts_controller.dart

if (success) {
  // Show notification
  NotificationService.showNotification(
    title: "Download Complete",
    body: metadata['title'] ?? 'Video downloaded successfully',
    payload: videoId,
  );
  
  // Save metadata...
}
```

## Summary

The offline download feature is now fully integrated! Users can:
- ✅ Download videos from shorts screen
- ✅ View downloaded videos in a dedicated screen
- ✅ Play videos offline
- ✅ Manage (select/delete) downloaded videos
- ✅ See storage statistics

All following your existing architecture patterns with GetX, repository pattern, and clean separation of concerns.


