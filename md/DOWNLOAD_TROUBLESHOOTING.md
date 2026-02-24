# Download Troubleshooting Guide (বাংলা)

## 🔧 Dio Configuration Fix - Critical Issues

### ❌ সমস্যা যা ছিল:

Terminal log দেখে বুঝা গেছে:
```
I/Choreographer: Skipped 5806 frames! The application may be doing too much work on its main thread.
```

এর মানে **main thread blocked** হয়ে গিয়েছিল।

### 🔍 মূল সমস্যাগুলো:

#### 1. **ResponseType Mismatch**
```dart
// ❌ আগে (WRONG):
..responseType = ResponseType.json  // Download এর জন্য json ব্যবহার করা হচ্ছিল

// ✅ এখন (CORRECT):
responseType: ResponseType.stream   // Download এর জন্য stream ব্যবহার করতে হবে
```

**কেন এটা সমস্যা ছিল:**
- Video download করার সময় পুরো file memory তে load করার চেষ্টা করছিল
- Large video file এর জন্য memory overflow হচ্ছিল
- App hang হয়ে যাচ্ছিল

#### 2. **Interceptor Forcing JSON**
```dart
// ❌ আগে (WRONG):
..responseType = ResponseType.json  // সব request এ force করা হচ্ছিল

// ✅ এখন (CORRECT):
if (options.responseType != ResponseType.stream) {
  options.responseType = ResponseType.json;
}
```

**কেন এটা সমস্যা ছিল:**
- Download method এ `ResponseType.stream` set করা হলেও
- Interceptor আবার সেটাকে `ResponseType.json` এ পরিবর্তন করে দিচ্ছিল
- Result: Download fail হচ্ছিল

#### 3. **BaseURL Conflict**
```dart
// ❌ আগে (WRONG):
..baseUrl = options.baseUrl.startsWith("http") ? "" : ApiEndPoint.instance.baseUrl;

// ✅ এখন (CORRECT):
final path = options.path;
if (path.startsWith("http")) {
  options.baseUrl = "";  // Full URL এর জন্য baseUrl খালি
} else {
  options.baseUrl = ApiEndPoint.instance.baseUrl;
}
```

**কেন এটা সমস্যা ছিল:**
- Video CDN URL (যেমন: `https://vz-4bdf02a2-a32.b-cdn.net/...`)
- এর সাথে baseUrl যোগ হয়ে wrong URL তৈরি হচ্ছিল

### ✅ সমাধান যা করা হয়েছে:

#### 1. Download Method Update
```dart
Future<ApiResponseModel> downloadFile(
  String url,
  String savePath, {
  Function(int, int)? onProgress,
}) async {
  try {
    final response = await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      options: Options(
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 10),
        
        // ✅ CRITICAL FIX: Stream response type for downloads
        responseType: ResponseType.stream,
        
        // ✅ Follow redirects for CDN URLs
        followRedirects: true,
        maxRedirects: 5,
        
        // ✅ Accept any status < 500
        validateStatus: (status) => status! < 500,
      ),
    );
    return _handleResponse(response);
  } catch (e) {
    if (e is DioException) {
      print('❌ Download Error: ${e.type}');
      print('❌ Error Message: ${e.message}');
      print('❌ Response: ${e.response?.statusCode}');
    }
    return _handleError(e);
  }
}
```

#### 2. Interceptor Update
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // ✅ Timeouts (can be overridden)
      options.connectTimeout ??= const Duration(seconds: 30);
      options.sendTimeout ??= const Duration(seconds: 30);
      options.receiveTimeout ??= const Duration(seconds: 30);
      
      // ✅ Don't force json for stream downloads
      if (options.responseType != ResponseType.stream) {
        options.responseType = ResponseType.json;
      }
      
      // ✅ Handle full URLs properly
      final path = options.path;
      if (path.startsWith("http")) {
        options.baseUrl = "";
      } else {
        options.baseUrl = ApiEndPoint.instance.baseUrl;
      }
      
      handler.next(options);
    },
  ),
);
```

#### 3. Better Error Logging
```dart
Future<bool> downloadVideo({
  required String url,
  required String savePath,
}) async {
  try {
    printInfo(info: '📥 Starting download from: $url');
    printInfo(info: '💾 Saving to: $savePath');
    
    final response = await repository.downloadVideo(
      url,
      savePath,
      onProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(0);
          downloadProgress.value = received / total;
          printInfo(info: '⬇️ Download progress: $progress%');
        }
      },
    );
    
    if (response.statusCode == 200) {
      printInfo(info: '✅ Download completed successfully');
      return true;
    } else {
      printInfo(info: '❌ Download failed with status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    printInfo(info: '❌ Download exception: $e');
    return false;
  }
}
```

## 🧪 Testing করার জন্য

### 1. Check Logs
Download button চাপার পর terminal এ এই logs দেখতে হবে:

```bash
✅ Success Case:
I/flutter: 📥 Starting download from: https://vz-4bdf02a2-a32.b-cdn.net/...
I/flutter: 💾 Saving to: /data/user/0/.../videos/12345.mp4
I/flutter: ⬇️ Download progress: 10%
I/flutter: ⬇️ Download progress: 25%
I/flutter: ⬇️ Download progress: 50%
I/flutter: ⬇️ Download progress: 75%
I/flutter: ⬇️ Download progress: 100%
I/flutter: ✅ Download completed successfully

❌ Error Case:
I/flutter: 📥 Starting download from: https://...
I/flutter: 💾 Saving to: /data/user/0/.../videos/12345.mp4
I/flutter: ❌ Download Error: DioExceptionType.badResponse
I/flutter: ❌ Error Message: Http status error [404]
I/flutter: ❌ Response: 404 - Not Found
```

### 2. Check File System
Download complete হলে file check করুন:

```dart
// Controller এ add করুন:
Future<void> checkDownloadedFile(String videoId) async {
  final path = await getVideoLocalPath(videoId);
  final file = File(path);
  
  if (await file.exists()) {
    final size = await file.length();
    printInfo(info: '✅ File exists: $path');
    printInfo(info: '📦 File size: ${(size / 1024 / 1024).toStringAsFixed(2)} MB');
  } else {
    printInfo(info: '❌ File not found: $path');
  }
}
```

### 3. Test Different Scenarios

#### A. Normal Download
```dart
// 1. Play করুন একটা video
// 2. Download button চাপুন
// 3. Log check করুন
// Expected: Video pause → Download → Video play
```

#### B. Large File Download
```dart
// 1. একটা বড় video (>50MB) download করুন
// 2. Progress logs দেখুন
// Expected: Progress 0% → 100% পর্যন্ত দেখাবে
```

#### C. Network Error
```dart
// 1. WiFi/Mobile data off করুন
// 2. Download try করুন
// Expected: Error message দেখাবে, app crash করবে না
```

#### D. Invalid URL
```dart
// 1. একটা invalid/expired URL দিয়ে test করুন
// Expected: 404 error, proper error handling
```

## 🔍 Common Issues & Solutions

### Issue 1: "Skipped frames" Warning
```
I/Choreographer: Skipped 5806 frames!
```

**Solution:**
- ✅ Video pause করা হচ্ছে download এর আগে
- ✅ ResponseType.stream ব্যবহার করা হচ্ছে
- ✅ Single download lock আছে

### Issue 2: Download Failed (404/403)
```
❌ Download Error: badResponse
❌ Response: 404
```

**Possible Causes:**
- URL expired হয়ে গেছে
- CDN access denied
- Wrong URL format

**Solution:**
```dart
// URL validate করুন:
if (!url.startsWith('http')) {
  printInfo(info: '❌ Invalid URL: $url');
  return false;
}

// Check URL accessibility:
try {
  final response = await dio.head(url);
  if (response.statusCode != 200) {
    printInfo(info: '❌ URL not accessible: ${response.statusCode}');
    return false;
  }
} catch (e) {
  printInfo(info: '❌ URL check failed: $e');
  return false;
}
```

### Issue 3: Timeout Error
```
❌ Download Error: receiveTimeout
```

**Solution:**
- ✅ Already increased to 10 minutes
- Check internet speed
- Try smaller video first

### Issue 4: Out of Storage
```
❌ Download exception: FileSystemException: No space left on device
```

**Solution:**
```dart
// Storage check করুন download এর আগে:
Future<bool> hasEnoughStorage(int requiredBytes) async {
  // Implement storage check
  final dir = await getApplicationDocumentsDirectory();
  // Check available space
  return true; // or false
}
```

## 📊 Performance Monitoring

### Add Performance Tracking
```dart
Future<void> downloadCurrentVideo() async {
  final startTime = DateTime.now();
  
  try {
    // Download logic
    
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    printInfo(info: '⏱️ Download took: ${duration.inSeconds} seconds');
  } catch (e) {
    // Error handling
  }
}
```

### Memory Monitoring
```dart
import 'dart:developer' as developer;

void monitorMemory() {
  developer.Timeline.startSync('Download');
  // Download logic
  developer.Timeline.finishSync();
}
```

## 🎯 Checklist

পরিবর্তন করার পর এই সব check করুন:

- [ ] ✅ Linter errors নেই
- [ ] ✅ Download logs properly দেখাচ্ছে
- [ ] ✅ Progress tracking কাজ করছে
- [ ] ✅ Video pause/resume হচ্ছে
- [ ] ✅ File properly save হচ্ছে
- [ ] ✅ Error handling কাজ করছে
- [ ] ✅ App crash করছে না
- [ ] ✅ Multiple download prevention কাজ করছে

## 📝 Files Changed

1. ✅ `lib/core/services/api/api_service.dart`
   - Fixed ResponseType for downloads
   - Fixed interceptor logic
   - Added better error logging

2. ✅ `lib/features/shorts/controller/shorts_controller.dart`
   - Added progress tracking
   - Added detailed logging
   - Better error messages

3. ✅ `lib/features/shorts/repository/shorts_repository.dart`
   - Added onProgress callback support

## 🚀 Next Steps

1. **Test করুন** সব scenarios
2. **Logs check করুন** terminal এ
3. **File verify করুন** device এ
4. **Performance monitor করুন**

---

**Fix Date:** ১১ জানুয়ারি ২০২৬  
**Status:** ✅ Ready for Testing

