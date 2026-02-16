# Offline Download Feature Documentation

## Overview
This feature allows users to download short videos for offline viewing, similar to YouTube's offline download functionality. Downloaded videos are stored in the app's private directory and are only accessible within the app.

## Architecture

### File Structure
```
lib/
├── features/
│   ├── download/
│   │   ├── model/
│   │   │   └── downloaded_video_model.dart          # Video metadata model
│   │   ├── service/
│   │   │   └── download_service.dart                # Download management service
│   │   ├── controller/
│   │   │   ├── downloaded_shorts_controller.dart    # List screen controller
│   │   │   └── downloaded_shorts_player_controller.dart # Player screen controller
│   │   └── presenter/
│   │       ├── downloaded_shorts_screen.dart        # List of downloaded videos
│   │       └── downloaded_shorts_player_screen.dart # Offline video player
│   └── shorts/
│       └── controller/
│           └── shorts_controller.dart               # Updated with download logic
└── core/
    └── config/
        └── route/
            └── app_routes.dart                      # Updated with new routes
```

## Features

### 1. Download Videos from Shorts Screen
- Users can download videos while watching shorts
- Videos are saved to app's private directory (`/data/user/0/com.app/app_flutter/videos/`)
- Metadata (title, description, thumbnail, etc.) is saved using SharedPreferences
- Duplicate download prevention
- Download progress indication

### 2. View Downloaded Videos
- Access downloaded videos from a dedicated screen
- Display video metadata: title, description, episode info, file size
- Show total storage used and video count
- Offline indicator badge on video thumbnails

### 3. Play Downloaded Videos Offline
- Full-screen vertical swipe player (similar to TikTok/YouTube Shorts)
- Playback from local storage (no internet required)
- Video progress bar with scrubbing
- Play/pause control
- Video looping

### 4. Manage Downloads
- **Selection Mode**: Long-press or tap edit icon to enable
- **Multi-select**: Select multiple videos for batch deletion
- **Select All/Deselect All**: Quick selection controls
- **Delete Videos**: Remove videos and free up storage
- **Delete Confirmation Dialog**: Prevents accidental deletion

## How to Use

### For Users

#### Downloading Videos
1. Open the Shorts screen and watch any video
2. Tap the **Download** button (bottom right action buttons)
3. Wait for download confirmation
4. Video is now available offline

#### Viewing Downloaded Videos
1. Navigate to **Downloaded Shorts** screen using `Get.toNamed(AppRoutes.downloadedShorts)`
2. See all downloaded videos with thumbnails and metadata
3. Check total storage used at the top
4. Tap any video to play offline

#### Playing Offline Videos
1. From downloaded shorts screen, tap any video
2. Swipe up/down to navigate between videos
3. Tap to play/pause
4. Drag progress bar to seek

#### Deleting Downloaded Videos
1. In downloaded shorts screen, tap the edit/mark icon (top right)
2. Select videos you want to delete
3. Tap **Delete** button at bottom
4. Confirm deletion in dialog

### For Developers

#### Download a Video
```dart
// In your controller
final controller = Get.find<ShortsScontroller>();
await controller.downloadCurrentVideo();
```

#### Navigate to Downloaded Shorts
```dart
Get.toNamed(AppRoutes.downloadedShorts);
```

#### Check if Video is Downloaded
```dart
final downloadService = DownloadService.instance;
final isDownloaded = await downloadService.isVideoDownloaded(videoId);
```

#### Get All Downloaded Videos
```dart
final downloadService = DownloadService.instance;
final videos = await downloadService.getAllDownloadedVideos();
```

#### Delete a Downloaded Video
```dart
final downloadService = DownloadService.instance;
final success = await downloadService.deleteDownloadedVideo(videoId);
```

## Data Models

### DownloadedVideoModel
```dart
class DownloadedVideoModel {
  final String videoId;           // Unique identifier (hash of URL)
  final String title;             // Video title
  final String description;       // Video description
  final String thumbnailUrl;      // Thumbnail image URL
  final String localPath;         // Local file path
  final String originalUrl;       // Original video URL
  final DateTime downloadedAt;    // Download timestamp
  final int fileSize;             // File size in bytes
  final String episodeNumber;     // Optional episode number
  final String seasonNumber;      // Optional season number
}
```

### Helper Properties
- `formattedFileSize` - Returns human-readable file size (e.g., "25.5 MB")
- `episodeInfo` - Returns formatted episode info (e.g., "S1 E3" or "EP.5")

## Storage

### Video Files
- Location: `{AppDocumentsDirectory}/videos/{videoId}.mp4`
- Private directory (not accessible via file manager)
- Automatically cleaned up when metadata is deleted

### Metadata
- Stored in: `SharedPreferences` with key `'downloaded_videos'`
- Format: JSON string array
- Persists across app restarts
- Automatically syncs with actual file existence

## Routes

```dart
// Navigate to downloaded shorts list
Get.toNamed(AppRoutes.downloadedShorts);

// Navigate to downloaded shorts player (auto-called from list)
Get.toNamed(
  AppRoutes.downloadedShortsPlayer,
  arguments: {
    'videos': List<DownloadedVideoModel>,
    'initialIndex': int,
  },
);
```

## API Integration

### Current Implementation (Demo)
The current implementation uses hardcoded metadata in `ShortsScontroller`:
```dart
final List<Map<String, String>> videoMetadata = [
  {
    'title': 'Amazing Short Video 1',
    'description': 'This is an amazing short video...',
    'thumbnailUrl': 'https://...',
    'episodeNumber': '1',
    'seasonNumber': '1',
  },
  // ...
];
```

### Production Implementation
Replace hardcoded metadata with API data:

1. **Fetch video details from your API**:
```dart
// In shorts_controller.dart
final videoDetails = await repository.getVideoDetails(videoId);
```

2. **Use API data when downloading**:
```dart
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

## Performance Considerations

### Video Player Optimization
- Only **one video controller** is kept in memory at a time
- Previous/next videos are disposed when scrolling away
- Prevents memory issues on low-end devices (tested on Samsung A20)
- Automatic controller cleanup on page change

### Storage Management
- Files are checked for existence when loading list
- Missing files are automatically removed from metadata
- Users can see total storage used
- Efficient JSON serialization/deserialization

## Error Handling

### Download Errors
- Network errors: Shows "Download failed" snackbar
- Duplicate downloads: Shows "Already Downloaded" snackbar
- Storage errors: Gracefully handled with error messages

### Playback Errors
- File not found: Shows error state with icon
- Initialization errors: Displays error message
- Automatically disposes failed controllers

### Deletion Errors
- Failed deletion: Shows error snackbar
- Partial deletion: Reports which files failed
- List automatically refreshes after successful deletion

## Testing Checklist

- [ ] Download a video from shorts screen
- [ ] Check video appears in downloaded shorts list
- [ ] Play downloaded video offline (turn off internet)
- [ ] Swipe up/down to navigate between downloaded videos
- [ ] Select multiple videos using selection mode
- [ ] Delete selected videos
- [ ] Verify storage stats update correctly
- [ ] Test with poor network conditions
- [ ] Test with low storage space
- [ ] Test app restart (videos should persist)

## Future Enhancements

### Planned Features
1. **Download Queue**: Download multiple videos in background
2. **Download Quality Selection**: Let users choose video quality
3. **Auto-delete**: Automatically delete old videos to free space
4. **Download Progress**: Show download percentage
5. **Sort/Filter**: Sort by date, size, or filter by series
6. **Search**: Search downloaded videos
7. **Export**: Share downloaded videos with other apps
8. **Sync**: Cloud backup of downloaded videos

### Performance Improvements
1. **Thumbnail Caching**: Cache video thumbnails locally
2. **Lazy Loading**: Load metadata in chunks for large lists
3. **Background Download**: Use WorkManager for background downloads
4. **Compression**: Compress videos before saving

## Troubleshooting

### Videos Not Appearing
- Check if SharedPreferences is initialized
- Verify video files exist in app documents directory
- Check device storage space

### Playback Issues
- Ensure video file is not corrupted
- Check file permissions
- Verify video codec is supported

### Storage Issues
- Clear app cache if storage is full
- Delete old videos manually
- Check if device has sufficient free space

## Dependencies

Required packages in `pubspec.yaml`:
```yaml
dependencies:
  get: ^4.7.2                    # State management & navigation
  video_player: ^latest          # Video playback
  path_provider: ^latest         # Get app directories
  shared_preferences: ^latest    # Persist metadata
  dio: ^latest                   # Download videos
```

## Support

For issues or questions:
1. Check this documentation
2. Review code comments in implementation files
3. Test in debug mode with verbose logging
4. Check device logs for errors

---

**Note**: This feature follows the app's existing architecture using GetX for state management, repository pattern for data access, and separation of concerns between model/view/controller layers.


