# 🔗 Deep Linking & Share Setup Guide
## Creepy Shorts App - Complete Implementation

This guide will help you set up deep linking and sharing functionality for your Creepy Shorts app with domain: `api.creepy-shorts.com`

---

## 📱 What's Implemented

✅ **Android Deep Linking** (Custom Scheme + HTTPS)
✅ **iOS Deep Linking** (Custom Scheme + Universal Links)
✅ **Share Functionality** (Facebook, Twitter, WhatsApp, System Share)
✅ **Web Fallback Page** (Auto-detects mobile & redirects to app/stores)
✅ **Domain Verification Files** (Android Asset Links + iOS AASA)

---

## 🚀 Quick Start

### 1. Android Setup

#### Step 1.1: Get SHA-256 Fingerprint

Run this command to get your app's SHA-256 fingerprint:

```bash
# For debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release keystore
keytool -list -v -keystore /path/to/your/release.keystore -alias your_alias_name
```

Copy the **SHA256** fingerprint (looks like: `14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5`)

#### Step 1.2: Update Asset Links File

Open: `web_fallback/.well-known/assetlinks.json`

Replace `YOUR_SHA256_FINGERPRINT_HERE` with your actual SHA-256 fingerprint.

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.victorsaulmendozamena.creepyshorts",
      "sha256_cert_fingerprints": [
        "14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5"
      ]
    }
  }
]
```

#### Step 1.3: Upload to Your Domain

Upload the following files to your domain:

```
https://api.creepy-shorts.com/.well-known/assetlinks.json
https://api.creepy-shorts.com/.well-known/apple-app-site-association
https://api.creepy-shorts.com/shorts/[VIDEO_ID]  (web fallback page)
```

**Important:** 
- Files must be accessible via HTTPS
- `assetlinks.json` must have `Content-Type: application/json`
- `apple-app-site-association` must NOT have `.json` extension

---

### 2. iOS Setup

#### Step 2.1: Get Team ID

1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Go to **Membership** section
3. Copy your **Team ID** (looks like: `ABCD1234EF`)

#### Step 2.2: Update Apple App Site Association

Open: `web_fallback/.well-known/apple-app-site-association`

Replace `TEAM_ID` with your actual Team ID:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "ABCD1234EF.com.victorsaulmendozamena.creepyshorts",
        "paths": ["/shorts/*", "/video/*"]
      }
    ]
  }
}
```

#### Step 2.3: Configure Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability** → Add **Associated Domains**
5. Add these domains:
   ```
   applinks:api.creepy-shorts.com
   applinks:www.api.creepy-shorts.com
   ```

#### Step 2.4: Verify Entitlements File

The entitlements file is already created at:
`ios/Runner/Runner.entitlements`

Make sure it's linked in your Xcode project.

---

### 3. Update App Store Links

#### Step 3.1: Play Store

Once your app is published on Google Play, update:

`web_fallback/index.html` → Line with Play Store link

```html
<a href="https://play.google.com/store/apps/details?id=com.victorsaulmendozamena.creepyshorts">
```

#### Step 3.2: App Store

Once your app is published on Apple App Store, update:

`web_fallback/index.html` → Line with App Store link

Replace `YOUR_APP_ID` with your actual App Store ID:

```html
<a href="https://apps.apple.com/app/id1234567890">
```

---

## 🧪 Testing Deep Links

### Android Testing

#### Method 1: ADB Command

```bash
# Test custom scheme
adb shell am start -W -a android.intent.action.VIEW -d "creepyshorts://shorts/VIDEO_ID_HERE" com.victorsaulmendozamena.creepyshorts

# Test HTTPS link
adb shell am start -W -a android.intent.action.VIEW -d "https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE" com.victorsaulmendozamena.creepyshorts
```

#### Method 2: Chrome Browser

1. Open Chrome on Android
2. Type in address bar: `creepyshorts://shorts/VIDEO_ID_HERE`
3. Or visit: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`

#### Method 3: Verify App Links

```bash
# Check if your domain is verified
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts

# Should show: "api.creepy-shorts.com: verified"
```

### iOS Testing

#### Method 1: Safari

1. Open Safari on iPhone
2. Visit: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`
3. Should see banner to open in app (if installed)

#### Method 2: Notes App

1. Open Notes app
2. Type the link: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`
3. Tap the link → Should open in app

#### Method 3: Custom Scheme

1. Open Safari
2. Type: `creepyshorts://shorts/VIDEO_ID_HERE`
3. Should prompt to open app

---

## 🌐 Web Server Configuration

### Upload Files

Your domain must serve these files:

```
https://api.creepy-shorts.com/
├── .well-known/
│   ├── assetlinks.json                    (Android verification)
│   └── apple-app-site-association         (iOS verification)
└── shorts/
    └── [VIDEO_ID]/                        (Web fallback page)
        └── index.html
```

### Nginx Configuration Example

```nginx
server {
    listen 443 ssl;
    server_name api.creepy-shorts.com;

    # SSL certificates
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;

    # Serve well-known files
    location /.well-known/assetlinks.json {
        alias /var/www/creepy-shorts/.well-known/assetlinks.json;
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }

    location /.well-known/apple-app-site-association {
        alias /var/www/creepy-shorts/.well-known/apple-app-site-association;
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }

    # Serve web fallback for shorts
    location /shorts/ {
        alias /var/www/creepy-shorts/web_fallback/;
        try_files $uri $uri/ /index.html;
    }

    # API routes
    location /api/ {
        proxy_pass http://backend_server;
    }
}
```

### Apache Configuration Example

```apache
<VirtualHost *:443>
    ServerName api.creepy-shorts.com
    
    SSLEngine on
    SSLCertificateFile /path/to/certificate.crt
    SSLCertificateKeyFile /path/to/private.key

    # Well-known files
    Alias /.well-known /var/www/creepy-shorts/.well-known
    <Directory "/var/www/creepy-shorts/.well-known">
        Header set Content-Type "application/json"
        Header set Access-Control-Allow-Origin "*"
        Require all granted
    </Directory>

    # Web fallback
    Alias /shorts /var/www/creepy-shorts/web_fallback
    <Directory "/var/www/creepy-shorts/web_fallback">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

---

## 📤 How Sharing Works

### User Flow

1. **User taps Share button** in app
2. **Share bottom sheet appears** with options:
   - Facebook
   - Twitter/X
   - WhatsApp
   - More (System Share Sheet)
   - Copy Link

3. **Link is generated**: 
   ```
   https://api.creepy-shorts.com/shorts/VIDEO_ID
   ```

4. **Recipient clicks link**:
   - **If app installed**: Opens directly in app to that video
   - **If app NOT installed**: Opens web fallback page with download buttons

### Share Link Format

```
https://api.creepy-shorts.com/shorts/[VIDEO_ID]
```

Example:
```
https://api.creepy-shorts.com/shorts/67920e5c51d46fa7f99f3dff
```

---

## 🔍 Verification & Troubleshooting

### Verify Android App Links

```bash
# Check domain verification status
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts

# Should output:
# api.creepy-shorts.com: verified
```

If not verified:
1. Check assetlinks.json is accessible
2. Verify SHA-256 fingerprint is correct
3. Wait 24-48 hours for Google to re-crawl

### Verify iOS Universal Links

1. Visit: https://branch.io/resources/aasa-validator/
2. Enter: `api.creepy-shorts.com`
3. Check if AASA file is valid

### Common Issues

#### ❌ "Link opens in browser instead of app"

**Android:**
- Check `android:autoVerify="true"` is present
- Verify domain with: `adb shell pm get-app-links`
- Clear app data and reinstall

**iOS:**
- Verify Associated Domains in Xcode
- Check AASA file is accessible (no .json extension)
- Test in Safari, not Chrome

#### ❌ "assetlinks.json returns 404"

- Ensure file is at: `https://api.creepy-shorts.com/.well-known/assetlinks.json`
- Check file permissions (should be readable)
- Verify Content-Type header is `application/json`

#### ❌ "App doesn't receive video ID"

- Check `DeepLinkService` is initialized in `main.dart`
- Verify route is registered in `AppRoutes`
- Check `ShortsScontroller` receives arguments

---

## 📊 Analytics & Monitoring

### Track Deep Link Opens

Add analytics to `DeepLinkService`:

```dart
void _handleDeepLink(String link) {
  // Track in analytics
  FirebaseAnalytics.instance.logEvent(
    name: 'deep_link_opened',
    parameters: {
      'link': link,
      'video_id': videoId,
    },
  );
  
  // Rest of your code...
}
```

### Monitor Share Actions

Track when users share:

```dart
// In ShareBottomSheet
void _shareViaSystemSheet(String link, String title) async {
  // Track share event
  FirebaseAnalytics.instance.logEvent(
    name: 'video_shared',
    parameters: {
      'video_id': videoId,
      'share_method': 'system',
    },
  );
  
  await Share.share('Check out this video: $title\n$link', subject: title);
}
```

---

## 🎯 Testing Checklist

Before releasing to production:

### Android
- [ ] SHA-256 fingerprint added to assetlinks.json
- [ ] assetlinks.json accessible at correct URL
- [ ] Custom scheme works (`creepyshorts://`)
- [ ] HTTPS links work
- [ ] App opens when clicking shared links
- [ ] Video ID is correctly passed and video plays

### iOS
- [ ] Team ID updated in apple-app-site-association
- [ ] AASA file accessible (without .json extension)
- [ ] Associated Domains configured in Xcode
- [ ] Universal Links work in Safari
- [ ] Custom scheme works
- [ ] App opens from shared links

### Web Fallback
- [ ] Page loads correctly
- [ ] Auto-detects mobile OS
- [ ] Shows correct store button (Play Store/App Store)
- [ ] Opens app if installed
- [ ] Redirects to store if app not installed

### Share Functionality
- [ ] All share buttons work (Facebook, Twitter, WhatsApp)
- [ ] System share sheet works
- [ ] Copy link works
- [ ] Shared link format is correct

---

## 🆘 Support & Resources

### Official Documentation

- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [app_links Package](https://pub.dev/packages/app_links)
- [share_plus Package](https://pub.dev/packages/share_plus)

### Testing Tools

- [Android App Links Assistant](https://developer.android.com/studio/write/app-link-indexing)
- [Branch.io AASA Validator](https://branch.io/resources/aasa-validator/)
- [Google Digital Asset Links Tester](https://developers.google.com/digital-asset-links/tools/generator)

---

## 📝 Summary

**What's Ready:**
1. ✅ Android deep linking configured
2. ✅ iOS deep linking configured
3. ✅ Share functionality implemented
4. ✅ Web fallback page created
5. ✅ Domain verification files ready

**What You Need to Do:**
1. Get SHA-256 fingerprint and update `assetlinks.json`
2. Get Apple Team ID and update `apple-app-site-association`
3. Upload files to your domain: `api.creepy-shorts.com`
4. Configure Associated Domains in Xcode
5. Update Play Store and App Store links
6. Test on both Android and iOS devices

**Important Notes:**
- Files must be accessible via HTTPS
- Domain verification can take 24-48 hours
- Test thoroughly before releasing to production
- Monitor analytics to track deep link usage

---

## 🎉 You're All Set!

Once you complete the setup steps above, users will be able to:
- Share videos from the app
- Open shared links directly in the app
- Be redirected to app stores if app is not installed
- Have a seamless sharing experience across platforms

Good luck! 🚀
