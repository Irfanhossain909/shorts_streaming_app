# Firebase Cloud Messaging (FCM) Setup Guide

## 📋 Overview
This guide covers the complete Firebase Cloud Messaging (FCM) setup for your Flutter application, enabling push notifications on both Android and iOS platforms.

## ✅ What's Already Configured

### 1. Dependencies (pubspec.yaml)
- ✅ `firebase_core: ^4.2.1`
- ✅ `firebase_messaging: ^16.0.4`
- ✅ `flutter_local_notifications: ^18.0.0`

### 2. Android Configuration
- ✅ `google-services.json` in `android/app/`
- ✅ Google Services plugin in `android/settings.gradle.kts`
- ✅ Google Services plugin applied in `android/app/build.gradle.kts`

### 3. iOS Configuration
- ✅ Background modes enabled in `Info.plist`
- ✅ `GoogleService-Info.plist` in `ios/Runner/`

### 4. Firebase Options
- ✅ `firebase_options.dart` with platform-specific configurations

### 5. Services Created
- ✅ `FCMService` - Handles all FCM operations
- ✅ `FCMController` - GetX controller for reactive state management
- ✅ `NotificationService` - Local notification handling

## 🔧 Implementation Details

### Main Features

#### 1. **FCM Token Management**
```dart
// Get FCM token
final token = await FCMService.getToken();
print('FCM Token: $token');

// Or use the controller
final fcmController = Get.find<FCMController>();
print('FCM Token: ${fcmController.fcmToken.value}');
```

#### 2. **Topic Subscription**
```dart
// Subscribe to topics for targeted notifications
await FCMService.subscribeToTopic('all_users');
await FCMService.subscribeToTopic('android_users');
await FCMService.subscribeToTopic('premium_users');

// Unsubscribe
await FCMService.unsubscribeFromTopic('all_users');
```

#### 3. **Notification States Handled**
- **Foreground**: App is open and visible
- **Background**: App is open but minimized
- **Terminated**: App is completely closed

### Notification Handlers

#### Foreground Notifications
When the app is open, notifications are automatically shown as local notifications via `NotificationService`.

```dart
// Handled in FCMService._handleForegroundMessage
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Shows local notification
  NotificationService.showNotification({
    'message': message.notification?.title,
    'type': message.notification?.body,
    'data': message.data,
  });
});
```

#### Background Notifications
When the app is in background (but not terminated):

```dart
// Handled in FCMService._handleMessageOpenedApp
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Navigate to specific screen based on notification data
  // TODO: Implement your navigation logic
});
```

#### Terminated State Notifications
When the app is opened from a completely closed state:

```dart
// Checked in FCMService.initialize()
final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
if (initialMessage != null) {
  // Handle the notification
}
```

## 🚀 How to Test

### Testing with Firebase Console

1. **Go to Firebase Console**
   - Navigate to: https://console.firebase.google.com/
   - Select your project: `raconliapp`

2. **Send a Test Notification**
   - Go to **Cloud Messaging** in the left menu
   - Click **Send your first message**
   - Fill in the form:
     - **Notification title**: "Test Notification"
     - **Notification text**: "This is a test message"
   - Click **Next**
   - Select **Target**: "User segment" → "All users"
   - Click **Next** → **Review** → **Publish**

### Testing with FCM Token

1. **Get your device token**:
```dart
// Check debug console logs after app launches
// Look for: 📱 FCM Token: YOUR_TOKEN_HERE
```

2. **Send notification using Firebase Console**:
   - In Firebase Console → Cloud Messaging
   - Click **New campaign** → **Notifications**
   - Enter notification details
   - In targeting, select **Send test message**
   - Enter your FCM token
   - Click **Test**

### Testing with Postman/cURL

```bash
curl -X POST "https://fcm.googleapis.com/fcm/send" \
  -H "Content-Type: application/json" \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Test Title",
      "body": "Test Body",
      "sound": "default"
    },
    "data": {
      "type": "test",
      "custom_key": "custom_value"
    }
  }'
```

**Note**: Get your Server Key from Firebase Console → Project Settings → Cloud Messaging → Server key

## 📱 Platform-Specific Configuration

### Android Setup
All Android configurations are already complete! The following are already set up:

1. ✅ Google Services Plugin
2. ✅ `google-services.json`
3. ✅ Correct package name: `com.raconligroup.watch_store`
4. ✅ Internet permission in AndroidManifest.xml

### iOS Setup
iOS configuration is complete, but here's what was done:

1. ✅ `GoogleService-Info.plist` added
2. ✅ Background modes enabled:
   - `fetch`
   - `remote-notification`

#### Additional iOS Requirements (If Needed)

If notifications don't work on iOS, ensure:

1. **Apple Developer Account Setup**:
   - Enable Push Notifications capability in your app ID
   - Create APNs authentication key or certificate
   - Upload to Firebase Console

2. **Xcode Configuration**:
   ```
   1. Open ios/Runner.xcworkspace in Xcode
   2. Select Runner in the project navigator
   3. Go to "Signing & Capabilities"
   4. Click "+ Capability"
   5. Add "Push Notifications"
   6. Add "Background Modes" (check "Remote notifications")
   ```

## 🎯 Usage Examples

### 1. Sending Token to Backend
```dart
// In your login or app initialization code
final token = await FCMService.getToken();
if (token != null) {
  // Send to your backend
  await yourApiService.sendFCMToken(token);
}

// Listen for token refresh
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  // Update token on your backend
  yourApiService.updateFCMToken(newToken);
});
```

### 2. Handling Notification Navigation
Update `FCMService._handleMessageOpenedApp()` method:

```dart
static void _handleMessageOpenedApp(RemoteMessage message) {
  final data = message.data;
  
  // Navigate based on notification type
  if (data['type'] == 'chat') {
    Get.toNamed('/chat', arguments: {
      'chatId': data['chatId'],
      'userId': data['userId'],
    });
  } else if (data['type'] == 'order') {
    Get.toNamed('/order-details', arguments: {
      'orderId': data['orderId'],
    });
  } else if (data['type'] == 'product') {
    Get.toNamed('/product-details', arguments: {
      'productId': data['productId'],
    });
  }
}
```

### 3. Managing User Preferences
```dart
// Subscribe to topics based on user preferences
class NotificationPreferences {
  static Future<void> updatePreferences({
    required bool orderUpdates,
    required bool chatMessages,
    required bool promotions,
  }) async {
    if (orderUpdates) {
      await FCMService.subscribeToTopic('order_updates');
    } else {
      await FCMService.unsubscribeFromTopic('order_updates');
    }
    
    if (chatMessages) {
      await FCMService.subscribeToTopic('chat_messages');
    } else {
      await FCMService.unsubscribeFromTopic('chat_messages');
    }
    
    if (promotions) {
      await FCMService.subscribeToTopic('promotions');
    } else {
      await FCMService.unsubscribeFromTopic('promotions');
    }
  }
}
```

### 4. Logout Handler
```dart
// When user logs out, delete the FCM token
await FCMService.deleteToken();

// Or using controller
final fcmController = Get.find<FCMController>();
await fcmController.deleteToken();
```

## 🔔 Notification Payload Structure

### Recommended Payload Format

```json
{
  "notification": {
    "title": "Order Delivered",
    "body": "Your order #12345 has been delivered successfully!",
    "sound": "default"
  },
  "data": {
    "type": "order",
    "orderId": "12345",
    "status": "delivered",
    "timestamp": "2025-11-26T17:47:26+06:00",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

### Data-Only Notifications
For silent notifications (no visible alert):

```json
{
  "data": {
    "type": "background_sync",
    "action": "refresh_data",
    "silentPush": "true"
  }
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Token is null**
   - **Solution**: Wait a few seconds after app initialization
   - **iOS**: Ensure APNs is configured in Firebase Console

2. **Notifications not received**
   - Check if notifications are enabled in device settings
   - Verify FCM token is valid
   - Check Firebase Console for errors
   - Ensure app is not in battery optimization mode (Android)

3. **Background notifications not working**
   - Verify background modes are enabled (iOS)
   - Check `firebaseMessagingBackgroundHandler` is registered
   - Ensure notification channel is properly configured (Android)

4. **Foreground notifications not showing**
   - Verify `NotificationService.initLocalNotification()` is called
   - Check notification permissions are granted
   - Ensure `@mipmap/ic_launcher` exists (Android)

### Debug Logging

All FCM operations include debug logging with emojis for easy identification:
- 📱 Token operations
- 📬 Foreground messages
- 🔔 Notification opened
- 📩 Background messages
- ✅ Success operations
- ❌ Errors

Look for these in your debug console.

## 📚 Additional Resources

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire FCM Plugin](https://firebase.flutter.dev/docs/messaging/overview)
- [Local Notifications Plugin](https://pub.dev/packages/flutter_local_notifications)

## 📝 Next Steps

### Backend Integration
You'll need to send the FCM token to your backend server so it can send notifications:

```dart
// Example API call
class NotificationRepository {
  Future<void> registerDevice(String fcmToken) async {
    await dio.post('/api/notifications/register', data: {
      'fcm_token': fcmToken,
      'device_type': Platform.operatingSystem,
      'device_id': await getDeviceId(),
    });
  }
}
```

### Server-Side (Node.js Example)
```javascript
const admin = require('firebase-admin');

// Send notification to specific device
async function sendNotification(fcmToken, title, body, data) {
  const message = {
    notification: { title, body },
    data: data,
    token: fcmToken,
  };
  
  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
  } catch (error) {
    console.log('Error sending message:', error);
  }
}

// Send to topic
async function sendToTopic(topic, title, body, data) {
  const message = {
    notification: { title, body },
    data: data,
    topic: topic,
  };
  
  await admin.messaging().send(message);
}
```

## ✨ Summary

Your Firebase Cloud Messaging setup is now complete! The implementation includes:

- ✅ FCM token generation and management
- ✅ Foreground notification handling
- ✅ Background notification handling
- ✅ Terminated state notification handling
- ✅ Topic subscription support
- ✅ GetX controller for reactive state management
- ✅ Local notification integration
- ✅ Platform-specific configurations (Android & iOS)
- ✅ Comprehensive error handling and logging

You can now:
1. Test notifications using Firebase Console
2. Integrate with your backend to send tokens
3. Customize notification navigation logic
4. Manage user notification preferences with topics

Happy coding! 🚀
