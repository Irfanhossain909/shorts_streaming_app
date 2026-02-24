# ShareBottomSheet URL Launch Error Fix

## Problem
When clicking on share buttons in `ShareBottomSheet`, the following errors appeared:
```
I/UrlLauncher: component name for whatsapp://send?text=... is null
I/UrlLauncher: component name for https://www.facebook.com/sharer/sharer.php?u=... is null
```

This happened because:
1. Android 11+ requires explicit declaration of external apps/URL schemes in the manifest
2. The URL launching logic didn't have proper fallback mechanisms for when apps weren't installed

## Solution

### 1. Updated AndroidManifest.xml (`android/app/src/main/AndroidManifest.xml`)

Added proper `<queries>` declarations for Android 11+ compatibility:

```xml
<queries>
    <!-- WhatsApp -->
    <package android:name="com.whatsapp" />
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="whatsapp" />
    </intent>
    
    <!-- Facebook -->
    <package android:name="com.facebook.katana" />
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="fb" />
    </intent>
    
    <!-- Twitter/X -->
    <package android:name="com.twitter.android" />
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="twitter" />
    </intent>
    
    <!-- Generic web browsing for fallbacks -->
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" />
    </intent>
</queries>
```

### 2. Enhanced Share Methods in `share_bottom_sheet.dart`

Implemented a **three-tier fallback system** for each sharing method:

#### Facebook Sharing
1. **First try**: Native Facebook app (`fb://` scheme)
2. **Fallback 1**: Web browser Facebook sharer
3. **Fallback 2**: System share sheet

#### Twitter/X Sharing
1. **First try**: Native Twitter app (`twitter://` scheme)
2. **Fallback 1**: Web browser Twitter intent
3. **Fallback 2**: System share sheet

#### WhatsApp Sharing
1. **First try**: Native WhatsApp app (`whatsapp://` scheme)
2. **Fallback 1**: WhatsApp Web
3. **Fallback 2**: System share sheet

### 3. Code Changes

**Before:**
```dart
void _shareToWhatsApp(String link, String title) async {
  final text = Uri.encodeComponent('Check out this video: $title\n$link');
  final url = 'whatsapp://send?text=$text';
  _launchUrl(url);
}
```

**After:**
```dart
void _shareToWhatsApp(String link, String title) async {
  try {
    final text = 'Check out this video: $title\n$link';
    
    // Try WhatsApp app first
    final whatsappUrl = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // Try WhatsApp web as fallback
    final whatsappWebUrl = Uri.parse('https://api.whatsapp.com/send?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(whatsappWebUrl)) {
      await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // If both fail, use system share sheet
    _shareViaSystemSheet(link, title);
  } catch (e) {
    // Last resort: use system share sheet
    _shareViaSystemSheet(link, title);
  }
}
```

## How to Test

1. **Rebuild the app** to apply AndroidManifest changes:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test scenarios:**
   - ✅ With WhatsApp installed → Should open WhatsApp
   - ✅ Without WhatsApp installed → Should fallback to system share
   - ✅ With Facebook app → Should open Facebook app
   - ✅ Without Facebook app → Should open web browser
   - ✅ All other cases → System share sheet works

## Why This Works

### Android 11+ Package Visibility
Starting from Android 11 (API level 30), apps must declare which external packages they want to interact with. Without the `<queries>` section, `canLaunchUrl()` returns `false` even if the app is installed, causing the "component name is null" error.

### Graceful Degradation
The three-tier fallback ensures:
1. **Best UX**: Native app if installed (seamless experience)
2. **Web fallback**: Browser-based sharing if app not available
3. **Universal fallback**: System share sheet works on all devices

### Error Recovery
The try-catch blocks ensure that even if URL parsing or launching fails, users can still share via the system share sheet.

## Files Modified

1. `/android/app/src/main/AndroidManifest.xml` - Added `<queries>` section
2. `/lib/features/shorts/widgets/share_bottom_sheet.dart` - Enhanced sharing methods

## Additional Notes

- The `share_plus` package handles the system share sheet reliably across all platforms
- `LaunchMode.externalApplication` ensures URLs open in external apps, not in-app webviews
- URL encoding is properly handled for special characters in titles
